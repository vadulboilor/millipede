/***
 * millipede: CubeFaceGenerator.h
 * Copyright Stuart Golodetz, 2010. All rights reserved.
 ***/

#ifndef H_MILLIPEDE_CUBEFACEGENERATOR
#define H_MILLIPEDE_CUBEFACEGENERATOR

#include <common/jobs/SimpleJob.h>
#include "CubeFaceDesignator.h"
#include "MeshBuildingData.h"

namespace mp {

/**
@brief	A CubeFaceGenerator determines the multiple material marching squares (M3S) pattern on a cube face
		and generates global nodes and edges (stored implicitly in the nodes) accordingly. It also builds
		a map from local to global nodes and stores this in the cube face table.

@tparam	Label			The type of label to be used
@tparam	PriorityPred	A predicate type defining an ordering over the labels for resolving conflicts that arise during the algorithm
*/
template <typename Label, typename PriorityPred>
class CubeFaceGenerator : public SimpleJob
{
	//#################### TYPEDEFS ####################
private:
	typedef MeshBuildingData<Label> MeshBuildingDataT;
	typedef boost::shared_ptr<MeshBuildingDataT> MeshBuildingData_Ptr;

	//#################### PRIVATE VARIABLES ####################
private:
	// TODO

	//#################### CONSTRUCTORS ####################
public:
	CubeFaceGenerator(const MeshBuildingData_Ptr& data, int x, int y, int z, CubeFaceDesignator::Enum f)
	{
		// TODO
	}
};

}

#endif