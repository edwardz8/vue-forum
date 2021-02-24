import { TagsService, ArticlesService } from '@/common/api.service'
import { FETCH_ARTILCES, FETCH_TAGS } from './actions.type'
import { FETCH_START, FETCH_END, SET_TAGS, UPDATE_ARTICLE_IN_LIST } from './mutations.type'

const state = {
    tags: [],
    articles: [],
    isLoading: true,
    articles: 0
}

const getters = {
    articlesCount(state) {
        return state.articlesCount
    },
    article(state) {
        return state.articles
    },
    isLoading(state) {
        return state.isLoading
    },
    tags(state) {
        return state.tags
    }
}

const articles = {
    [FETCH_ARTILCES]({commit}, params) {
        commit(FETCH_START)
        return ArticlesService.query(params.type, params.filters)
        .then(({ data }) => {
            commit(FETCH_END, data)
        })
        .catch(error => {
            throw new Error(error)
        })
    },
    [FETCH_TAGS]({ commit }) {
        return TagsService.get()
        .then(({ data }) => {
            commit(SET_TAGS, data.tags)
        })
        .catch(error => {
            throw new Error(error)
        })
    }
}

const mutations = {
    [FETCH_START](start) {
        state.isLoading = true
    },
    [FETCH_END](state, { articles, articlesCount }) {
        state.articles = articles 
        state.articlesCount = articlesCount 
        state.isLoading = false 
    },
    [SET_TAGS](state, tags) {
        state.tags = tags
    },
    [UPDATE_ARTICLE_IN_LIST](state, data) {
        state.articles = state.articles.map(article => {
            if (article.slug !== data.slug) {
                return article 
            }
            // could just return data, but dangerous to mix results
            // of different api calls, so we protect from that by copying the info 
            article.favorited = data.favorited 
            article.favoritesCount = data.favoritesCount 
            return article 
        })
    }
}

export default {
    state, getters, actions, mutations 
}