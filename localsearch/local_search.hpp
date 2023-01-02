//
//  local_search.hpp
//  localsearch
//
//  Created by 黄伟 on 2023/1/2.
//

#ifndef local_search_hpp
#define local_search_hpp

//#include <stdio.h>
#include <string>
#include <xapian.h>

class LocalSearch {
public:
  explicit LocalSearch(std::string &path);
  explicit LocalSearch(std::string &&path);
  LocalSearch operator=(LocalSearch &ls)=delete;
  ~LocalSearch();
  void search(std::string &term);
private:
  void init();
  std::string dbpath;
  
  Xapian::WritableDatabase *database;
  Xapian::TermGenerator *termGenerator;
  Xapian::Stem *stem;
};

#endif /* local_search_hpp */
