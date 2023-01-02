//
//  local_search.cpp
//  localsearch
//
//  Created by 黄伟 on 2023/1/2.
//

#include "local_search.hpp"
#include <iostream>

using namespace Xapian;

LocalSearch::LocalSearch(std::string &path) : dbpath(path) {
  init();
}

LocalSearch::LocalSearch(std::string &&path) : dbpath(path) {
  std::cout << "rvalue reference constructor get called" << std::endl;
  init();
}

void LocalSearch::init() {
  database = new WritableDatabase(dbpath, DB_CREATE_OR_OPEN);
  termGenerator = new TermGenerator();
  stem = new Stem("en");
  termGenerator->set_database(*database);
  termGenerator->set_flags(TermGenerator::FLAG_CJK_NGRAM);
  termGenerator->set_stemmer(*stem);
  std::cout << "build database of xapian" << std::endl;
}

LocalSearch::~LocalSearch() {
  delete stem;
  delete termGenerator;
  delete database;
}

void LocalSearch::search(std::string &term) {
  std::cout << "search for " << term << "(xapian" << Xapian::version_string() << ")" << std::endl;
}
