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

void LocalSearch::index_doc(std::string &docId, IndexDoc &doc) {
  assert(!docId.empty());
  Xapian::Document document;
  termGenerator->set_document(document);
  
  document.add_boolean_term(docId);
  
  valueno vn = 0;
  for (IndexDoc::iterator i = doc.begin(); i != doc.end(); ++i) {
    const std::string &key = i->first;
    const IndexValue &val = i->second;
    std::cout << "key" << key << ",val" << val.getVal() << std::endl;
    
    termGenerator->index_text(val.getVal(), 1, val.getShortKey());
    termGenerator->index_text(val.getVal());
    termGenerator->increase_termpos();
    
    document.add_value(vn, val.getVal());
    ++vn;
  }
  
  docid insertDocId = database->replace_document(docId, document);
  std::cout << "insert doc id " << insertDocId << std::endl;
}

LocalSearch::~LocalSearch() {
  delete stem;
  delete termGenerator;
  delete database;
}

void LocalSearch::search(std::string &term) {
  std::cout << "search for " << term << "(xapian" << Xapian::version_string() << ")" << std::endl;
}
