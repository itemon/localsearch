//
//  index_value.cpp
//  localsearch
//
//  Created by 黄伟 on 2023/1/3.
//

#include "index_value.hpp"

IndexValue::IndexValue() : val(""), shortKey(""), valType(IndexValueType::Text) {
  
}

IndexValue::IndexValue(std::string &val_, std::string &shortKey_, IndexValueType &valType_) : val(val_), shortKey(shortKey_), valType(valType_) {
  
}

IndexValue::~IndexValue() {
  
}

bool IndexValue::operator==(IndexValue &other) {
  return val == other.val
    && shortKey == other.shortKey
    && valType == other.valType;
}
