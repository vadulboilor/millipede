/***
 * millipede: LiverIdentifier3D.h
 * Copyright Stuart Golodetz, 2010. All rights reserved.
 ***/

#ifndef H_MILLIPEDE_LIVERIDENTIFIER3D
#define H_MILLIPEDE_LIVERIDENTIFIER3D

#include <common/jobs/SimpleJob.h>
#include "StratifiedRegionGrowingFeatureIdentifier.h"

namespace mp {

class LiverIdentifier3D : public SimpleJob, public StratifiedRegionGrowingFeatureIdentifier
{
	//#################### CONSTRUCTORS ####################
public:
	LiverIdentifier3D(const DICOMVolume_CPtr& dicomVolume, const VolumeIPF_Ptr& volumeIPF);

	//#################### PUBLIC METHODS ####################
public:
	int length() const;

	//#################### PRIVATE METHODS ####################
private:
	void execute_impl();
	bool is_liver_candidate(const PFNodeID& node, const BranchProperties& properties) const;
};

}

#endif
