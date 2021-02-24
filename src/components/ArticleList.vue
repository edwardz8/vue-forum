<template>
    <div>
        <div v-if="isLoading" class="article-preview">Loading articles...</div>
        <div v-else>
            <div v-if="articles.length === 0" class="article-preview">
                No articles are here...yet.
            </div>
            <RwvArticlePreview v-for="(article, index) in articles" :key="article.title + index" :article="article" />
            <VPagination :pages="pages" :currentPage.sync="currentPage" />
        </div>
    </div>
</template>