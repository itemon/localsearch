//
//  index_value.hpp
//  localsearch
//
//  Created by 黄伟 on 2023/1/3.
//

#ifndef index_value_hpp
#define index_value_hpp

#include <iostream>
#include <string>

class IndexValue {
public:
  enum IndexValueType {
    Text,
    Numberic,
  };
  
  IndexValue();
  IndexValue(std::string &val_, std::string &shortKey_, IndexValueType &valType_);
//  IndexValue(IndexValue &val);
//  IndexValue(IndexValue &&val);
//  IndexValue operator=(IndexValue &val);
  ~IndexValue();
  
  bool operator==(IndexValue &iv);
  
  const std::string &getVal() const {return val;};
  const IndexValueType &getValType() const {return valType;};
  
  const std::string &getShortKey() const {return shortKey;};
  
private:
  std::string val;
  IndexValueType valType;
  std::string shortKey;
};

#endif /* index_value_hpp */
