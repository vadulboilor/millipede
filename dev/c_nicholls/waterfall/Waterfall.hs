{-# LANGUAGE  FlexibleInstances #-}
module Waterfall(waterfall,mkNode,Node(Node),Edge(Edge),mkEdge,Mergable(union),getRegion,getEdges,getNode,getWeight) where

import List (sortBy)
data Node a = Node !a ![Edge a] 
data Edge a = Edge Int (Node a) 

-- f applied to an edge returns the edge after merging. The boolean value indicates 
-- whether or not the edge contained a regional minimum amongst its children

class Mergable a where
  union :: a -> a -> a

waterfall :: Mergable a => Node a -> Node a
waterfall (Node r []) = Node r []
waterfall (Node r es) = (getNode.fst.f) (Edge  (maximum [i| Edge i t <- es]) (Node r es))
  
-- f :: Mergable a => Edge a -> (Edge a,Bool)
-- f n@(Edge w (Node r [])) = (n,False)
-- f (Edge w (Node r es) ) = 
--   let ((e,b):es') = sortBy cmpEdge (map f es) in
--   let w' = getWeight e in 
--     case (b==True && (w'<=w)) of 
--     True   ->  (join r ((e,False): es') w, True)
--     False  ->  (join r ((e,b): es')  w, flag (w'>=w)) 
    
  
f :: Mergable a => Edge a -> (Edge a,Bool)
f n@(Edge w (Node r [])) = (n,False)
f (Edge w (Node r es) ) = 
  let w' = getWeight e in 
    case (b==True && (w'<=w)) of 
    True   ->  (join r ((e,False): es') w, True)
    False  ->  (join r ((e,b): es')  w, flag (w'>=w)) 
  where ((e,b):es') = sortBy cmpEdge (map f es)
    

{--
recurse: es''
merge the minimum child
merge the non
--}
join ::  Mergable a=> a -> [(Edge a,Bool)] -> Int -> Edge a
join r [] w = Edge w (Node r [])
join r ((Edge v n,b):es) w 
 | b   =        Edge w' (Node r' ((Edge v n ):es')) 
 | otherwise  = Edge w' (Node r''  es'') 
  where
    r'' = (id (union r' (getRegion n)))
    es'' = (es' ++ getEdges n)
    Edge w' (Node r' es') = join r es w


-- Auxillary functions 




flag :: Bool -> Bool
flag True = False
flag False = True

cmpEdge :: Mergable a =>(Edge a,Bool) -> (Edge a,Bool) -> Ordering
cmpEdge ((Edge w1 x),b1) ((Edge w2 y),b2) 
  | w1 == w2 = compare b2 b1
  | otherwise = compare w1 w2

type Region = [Char]

getNode :: Edge a -> Node a
getNode (Edge w n) = n

getWeight (Edge w n ) = w

getRegion :: Node a -> a
getRegion (Node r es) = r

getEdges :: Node a-> [Edge a]
getEdges (Node r es) = es


mkNode :: Mergable a =>a -> [Edge a]->  Node a
mkNode a es = Node a es

mkEdge :: Mergable a => Node a -> Int -> Edge a
mkEdge n v = Edge v n


instance Mergable [Char] where
  union a b  = a ++ b
---- Stuff for testing ----------

  {- f:
To combine all the correct edges:
From a given Node, with weight w leaing to it,
we first apply f to each of its chlidren to get the 
correctly merged sub-Nodes along with a boolean value 
representing whether or not that child has been merged 
with a regional minima below it. 

If the Node is a leaf, then we're done. It is not
merged with anything below it. 

If none of the children where merged with a RM then we 
are safe to merge with all the children since this won't 
bring two RM together. If w is graeter than any of the weights 
leading to the children then our Node has been merged with a RM.

Assume that some of the children merged with a RM. We still want 
to merge with every child that did not merge with a RM since doing
so will not join any RM but we may also want to merge with one of
the children that did since it may have greatest claim over the 
current Node. A child will have this claim if the weight leading 
to it is less than the weights of all other edges leading to the
curretn Node. 
The Node we're at merged with a RM if it
-merged with one of its children that had merged or if
-any of its children that did not merge with a RM formed a RM themselves. 
 This relies on the same condition as before: that w is not smaller than
 the weight of any edge leading away from the Node. 
-}  
    
