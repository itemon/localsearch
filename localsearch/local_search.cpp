//
//  local_search.cpp
//  localsearch
//
//  Created by 黄伟 on 2023/1/2.
//

#include "local_search.hpp"

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

void LocalSearch::commit_index() {
  database->commit();
}

void LocalSearch::index_doc(IndexDoc &doc) {
  Xapian::Document document;
  termGenerator->set_document(document);
  
  std::string id;
  for (IndexDoc::iterator i = doc.begin(); i != doc.end(); ++i) {
    std::string key = i->first;
    std::string val = i->second;
    std::cout << "key" << key << ",val" << val << std::endl;
    
    if (key == "id") {
      document.add_boolean_term(val);
      id = val;
      continue;
    }
    
    termGenerator->index_text(val, 1, key);
    termGenerator->index_text(val);
    termGenerator->increase_termpos();
  }
  
  if (!id.empty()) {
    docid insertDocId = database->replace_document(id, document);
    std::cout << "insert doc id " << insertDocId << std::endl;
  }
}

LocalSearch::~LocalSearch() {
  delete stem;
  delete termGenerator;
  delete database;
}

void LocalSearch::search(std::string &term) {
  std::cout << "search for " << term << "(xapian" << Xapian::version_string() << ")" << std::endl;
}
