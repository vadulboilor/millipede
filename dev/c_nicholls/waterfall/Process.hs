module Process(
  bounds,
  output,
  getAdjacencyList,
  arrayToNode,freeze'',
  Adjacency,Point
  	) where


import SkewHeap (Heap,fromList,merge,insert,getMin,toList  )
import Data.Array.IO
import Data.Array.Unboxed       (IArray, Ix, UArray, amap, bounds, elems, listArray, (!)	)
import List(sort,sortBy)
import Data.Word                (Word8, Word16)
import Waterfall(waterfall,Node,mkNode,Edge,mkEdge,Mergable(union),getRegion,getEdges,getNode,getWeight)
import PGM
  ( pgmToArray,
    pgmsToArrays,
    pgmToArrayWithComments, pgmsToArraysWithComments,
    arrayToPgmWithComment,
    pgmsFromFile, pgmsFromHandle,
    arrayToPgm, arrayToFile, arrayToHandle, arraysToHandle,
    arraysToFile
  )

type Adjacency  = (Int,Voxel,Voxel)
type Region = [Point]
type Point = (Int,Int)
type Voxel = (Int,Point)


neighbours :: UArray Point Int -> Point -> Point -> [Adjacency]
neighbours   arr  (a,b) (x,y) = neighbours' arr  (a,b) (x,y) ls'
  where
    ls' = filter (\(c,d) -> 0<=c&&0<=d&&c<x&&d<y) ls
    ls = [(a,b+1),(a+1,b),(a,b-1),(a-1,b),(a+1,b+1),(a-1,b-1),(a+1,b-1),(a-1,b+1)]

neighbours' :: UArray Point Int -> Point -> Point -> [Point] -> [Adjacency]
neighbours' arr  (a,b) (x,y) [] =  []
neighbours' arr  (a,b) (x,y) (p:ps) = 
      let v1 = arr!(a,b) in
      let v2 = arr! p in
      let rs = neighbours' arr  (a,b) (x,y) ps in
      ((abs (v1-v2), (v1,(a,b)),(v2,p) ):rs)

               
---- IO Array Functions ----            
fillIn :: Node (Heap Voxel) -> IOUArray Point Int -> IO (IOUArray Point Int)
fillIn node ar = do
  {let rs' = toList (getRegion node)
  ;let x = avg rs'
  ;mapM (\v -> writeArray ar (snd v) x) rs'
  ;ar' <- foldR (fillIn.getNode) ar (getEdges node)
  ;return $!  ar
  }

arrayToNode :: IOArray Point [(Int, Voxel)] -> Point -> (Int, Voxel) -> IO (Edge (Heap Voxel))
arrayToNode arr miss (n,(v,p))  = do
  { --print p
  ;ls <-readArray arr p
  ;let ls' = remove miss ls
  ;let ls'' = remove p ls'
  ;es <- mapM  (arrayToNode arr p) ls''
  ;return $! mkEdge (mkNode(fromList [(v,p)]) es) n
  }

remove :: Point -> [(Int,Voxel)] -> [(Int,Voxel)]
remove p [] = []
remove p ((w,(v,a)):ps) 
  | a ==p = remove p ps
  | otherwise = ((w,(v,a)):remove p ps)

getAdjacencyList :: (IArray UArray Int) =>  UArray Point Int -> IO (IOArray Point [(Int,Voxel)])
getAdjacencyList arr = do 
  {let ((a,b),(c,d)) = bounds arr
  ;brr <- newArray ((a,b),(c,d)) [] :: IO (IOArray Point [(Int,Voxel)]	)
  ;writeArray brr (0,0) [(0,(0,(0,0)))]	
  ;let e = neighbours arr (0,0) (c,d)
  ;print (c*d-1)
  ;pickNAdjacencys (c*d-1) (c,d) (fromList e) arr brr []
  }

pickNAdjacencys ::  Int-> Point ->Heap Adjacency-> UArray Point Int -> IOArray Point [(Int,Voxel)] -> [Adjacency] -> IO (IOArray Point [(Int,Voxel)])
pickNAdjacencys 0 is es ar ls end    = do {return $!  ls}
pickNAdjacencys n is h ar ls end = do
  {
  ;let ((w,a,b),h') = getMin h
  ;l1 <- readArray ls  (snd a)
  ;l2 <- readArray ls  (snd b)
  ;if((l1==[]||l2==[]))
     then do
       {writeArray ls (snd a) ((w,b):l1)
       ;writeArray ls (snd b) ((w,a):l2)
       ;let ns = neighbours ar (snd b) is
       ;l <- (filter' ls [] ns)
       ;let h'' = merge h' (fromList l)
       ;pickNAdjacencys (n-1) is h'' ar ls ((w,a,b):end) 
       }
     else do {(pickNAdjacencys n is h' ar ls end)}
  }

filter' :: IOArray Point [(Int,Voxel)]-> [Adjacency]-> [Adjacency]-> IO ([Adjacency])
filter' br ls [] = do{ return $!  ls}
filter' br ls ((a,b,(c,d)):xs) = do
  {l <- readArray br d
  ;if l == [] 
    then filter' br ((a,b,(c,d)):ls) xs
    else filter' br ls xs
  }

---  Main  -------------  
output :: (Point, Point) -> Node (Heap Voxel) -> IO (UArray Point Word16)
output bounds tree = do
  {arr <- newArray bounds 0 :: IO (IOUArray Point Int)
  ;arrr <- fillIn tree arr
  ;arrrr <- freeze' arrr
  ;let arrrrr = amap (fromIntegral :: Int -> Word16) arrrr
  ;return $!  arrrrr
  }


--- Other Functions ---------
instance Ord a => Mergable (Heap a) where
  union = merge

freeze' :: ( MArray a Int IO, IArray UArray Int) => a Point Int -> IO (UArray Point Int)
freeze' = freeze

freeze'' :: ( MArray a b IO, IArray UArray b) => a Point b -> IO (UArray Point b)
freeze'' = freeze

    
foldR            :: (Monad m) => (a -> b -> m b) -> b -> [a] -> m b
foldR f a []     = return $!  a
foldR f a (x:xs) = foldR f a xs >>= \y -> f x y

avg :: [Voxel] -> Int
avg [] = 109
avg ((x,(a,b)):xs) = mod ((a+b)*13 + 17*(avg xs) ) 255