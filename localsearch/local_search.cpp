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
    
    if (val.getValType() == IndexValue::Numberic) {
      termGenerator->index_text_without_positions(val.getVal());
    } else {
      termGenerator->index_text(val.getVal(), 1, val.getShortKey());
      termGenerator->index_text(val.getVal());
    }
    termGenerator->increase_termpos();
    
    document.add_value(vn, val.getVal());
    ++vn;
  }
  
//  document.add_value(vn, docId);
  
  docid insertDocId = database->replace_document(docId, document);
  std::cout << "insert doc id " << insertDocId << std::endl;
}

LocalSearch::~LocalSearch() {
  delete stem;
  delete termGenerator;
  delete database;
}

void LocalSearch::search(const std::string &term, const void *context, search_callback callback) {
  std::cout << "search for " << term << "(xapian" << Xapian::version_string() << ")" << std::endl;
  QueryParser queryparser;
  queryparser.set_stemmer(*stem);
  
  queryparser.add_prefix("corp_name", "CN");
  queryparser.add_prefix("corp_industry_con", "INC");
  queryparser.add_prefix("corp_industry", "IN");
  queryparser.add_prefix("corp_net_income", "NI");
  queryparser.add_prefix("corp_net_profit", "PT");
  
  Enquire enquire(*database);
  Query query(queryparser.parse_query(term, QueryParser::FLAG_CJK_NGRAM));
  enquire.set_query(query);
  
  MSet search_result = enquire.get_mset(0, 20);
  for (MSetIterator it = search_result.begin(); it != search_result.end(); ++it) {
    Document doc = it.get_document();
//    docid did = doc.get_docid();
    /*std::cout << "doc 0:" << doc.get_value(0)
      << " 1:" << doc.get_value(1) << "2:" << doc.get_value(2)
      << "3:" << doc.get_value(3) << ", 4:" << doc.get_value(4) << std::endl;*/
    callback(context, doc.get_value(4)/*corp_name*/,
             doc.get_value(2)/*corp_industry_con*/,
             doc.get_value(3)/*corp_industry*/,
             doc.get_value(0)/*corp_net_profit*/,
             doc.get_value(1)/*corp_net_income*/,
             std::to_string(doc.get_docid()));
  }
}
