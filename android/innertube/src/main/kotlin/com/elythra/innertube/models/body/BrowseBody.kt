package com.elythra.innertube.models.body

import com.elythra.innertube.models.Context
import com.elythra.innertube.models.Continuation
import kotlinx.serialization.Serializable

@Serializable
data class BrowseBody(
    val context: Context,
    val browseId: String?,
    val params: String?,
    val continuation: String?
)
