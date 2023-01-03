//
//  index_value.cpp
//  localsearch
//
//  Created by 黄伟 on 2023/1/3.
//

#include "index_value.hpp"

IndexValue::IndexValue() : val(""), valType(IndexValueType::Text) {
  
}

IndexValue::IndexValue(std::string &val_, IndexValueType &valType_) : val(val_), valType(valType_) {
  
}

IndexValue::~IndexValue() {
  
}
