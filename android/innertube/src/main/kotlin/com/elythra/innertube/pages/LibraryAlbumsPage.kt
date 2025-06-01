package com.elythra.innertube.pages

import com.elythra.innertube.models.Album
import com.elythra.innertube.models.AlbumItem
import com.elythra.innertube.models.Artist
import com.elythra.innertube.models.ArtistItem
import com.elythra.innertube.models.MusicResponsiveListItemRenderer
import com.elythra.innertube.models.MusicTwoRowItemRenderer
import com.elythra.innertube.models.PlaylistItem
import com.elythra.innertube.models.SongItem
import com.elythra.innertube.models.YTItem
import com.elythra.innertube.models.oddElements
import com.elythra.innertube.utils.parseTime

data class LibraryAlbumsPage(
    val albums: List<AlbumItem>,
    val continuation: String?,
) {
    companion object {
        fun fromMusicTwoRowItemRenderer(renderer: MusicTwoRowItemRenderer): AlbumItem? {
            return AlbumItem(
                        browseId = renderer.navigationEndpoint.browseEndpoint?.browseId ?: return null,
                        playlistId = renderer.thumbnailOverlay?.musicItemThumbnailOverlayRenderer?.content
                            ?.musicPlayButtonRenderer?.playNavigationEndpoint
                            ?.watchPlaylistEndpoint?.playlistId ?: return null,
                        title = renderer.title.runs?.firstOrNull()?.text ?: return null,
                        artists = null,
                        year = renderer.subtitle?.runs?.lastOrNull()?.text?.toIntOrNull(),
                        thumbnail = renderer.thumbnailRenderer.musicThumbnailRenderer?.getThumbnailUrl() ?: return null,
                        explicit = renderer.subtitleBadges?.find {
                            it.musicInlineBadgeRenderer?.icon?.iconType == "MUSIC_EXPLICIT_BADGE"
                        } != null
                    )
        }
    }
}
