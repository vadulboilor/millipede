/***
 * millipede: AbdominalFeature.h
 * Copyright Stuart Golodetz, 2010. All rights reserved.
 ***/

#ifndef H_MILLIPEDE_ABDOMINALFEATURE
#define H_MILLIPEDE_ABDOMINALFEATURE

#include <string>
#include <vector>

#include <common/util/EnumUtil.h>

namespace mp {

namespace AbdominalFeature {

enum Enum
{
	KIDNEY,
	LIVER,
	COUNT,
};

}

template <> AbdominalFeature::Enum enum_begin();
template <> AbdominalFeature::Enum enum_end();
AbdominalFeature::Enum& operator++(AbdominalFeature::Enum& e);

std::string feature_key(AbdominalFeature::Enum e);
std::string feature_name(AbdominalFeature::Enum e);

}

#endif
