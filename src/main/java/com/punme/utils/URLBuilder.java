package com.punme.utils;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Tosha on 11/11/2016.
 */
public class URLBuilder {
    private String url;
    private List<Query> queries = new ArrayList<Query>();

    private class Query {
        private String queryType;
        private String query;
        public Query(String queryType, String query) {
            this.queryType = queryType;
            this.query = query;
        }
        public String getQueryType() {
            return this.queryType;
        }
        public String getQuery() {
            return this.query;
        }
    }


    public URLBuilder() {
        url = "";
    }
    public URLBuilder(String baseUrl) {
        url = baseUrl;
    }

    public void appendQuery(String queryType, String query) {
        queries.add(new Query(queryType, query));
    }

    public String toString() {
        StringBuilder concatUrl = new StringBuilder(url);
        for (Query q: queries) {
            concatUrl.append("&");
            concatUrl.append(q.getQueryType());
            concatUrl.append("=");
            concatUrl.append(q.getQuery());
        }
        return concatUrl.toString();
    }
}