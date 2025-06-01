package com.elythra.music.models

import com.metrolist.innertube.models.YTItem
import com.elythra.music.db.entities.LocalItem

data class SimilarRecommendation(
    val title: LocalItem,
    val items: List<YTItem>,
)
