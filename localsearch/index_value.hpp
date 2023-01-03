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
  IndexValue(std::string &val, IndexValueType &valType);
//  IndexValue(IndexValue &val);
//  IndexValue(IndexValue &&val);
//  IndexValue operator=(IndexValue &val);
  ~IndexValue();
  
  const std::string &getVal() const {return val;};
  const IndexValueType &getValType() const {return valType;};
  
private:
  std::string val;
  IndexValueType valType;
};

#endif /* index_value_hpp */
