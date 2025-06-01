package com.elythra.music.ui.screens.settings

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarScrollBehavior
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import coil.compose.AsyncImage
import com.metrolist.innertube.YouTube
import com.metrolist.innertube.utils.parseCookieString
import com.elythra.music.App.Companion.forgetAccount
import com.elythra.music.LocalPlayerAwareWindowInsets
import com.elythra.music.R
import com.elythra.music.constants.AccountChannelHandleKey
import com.elythra.music.constants.AccountEmailKey
import com.elythra.music.constants.AccountNameKey
import com.elythra.music.constants.DataSyncIdKey
import com.elythra.music.constants.InnerTubeCookieKey
import com.elythra.music.constants.UseLoginForBrowse
import com.elythra.music.constants.VisitorDataKey
import com.elythra.music.constants.YtmSyncKey
import com.elythra.music.ui.component.IconButton
import com.elythra.music.ui.component.InfoLabel
import com.elythra.music.ui.component.PreferenceEntry
import com.elythra.music.ui.component.PreferenceGroupTitle
import com.elythra.music.ui.component.SwitchPreference
import com.elythra.music.ui.component.TextFieldDialog
import com.elythra.music.ui.utils.backToMain
import com.elythra.music.utils.dataStore
import com.elythra.music.utils.rememberPreference
import com.elythra.music.viewmodels.HomeViewModel
import kotlinx.coroutines.runBlocking

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AccountSettings(
    navController: NavController,
    scrollBehavior: TopAppBarScrollBehavior,
) {
    val context = LocalContext.current

    val (accountNamePref, onAccountNameChange) = rememberPreference(AccountNameKey, "")
    val (accountEmail, onAccountEmailChange) = rememberPreference(AccountEmailKey, "")
    val (accountChannelHandle, onAccountChannelHandleChange) = rememberPreference(AccountChannelHandleKey, "")
    val (innerTubeCookie, onInnerTubeCookieChange) = rememberPreference(InnerTubeCookieKey, "")
    val (visitorData, onVisitorDataChange) = rememberPreference(VisitorDataKey, "")
    val (dataSyncId, onDataSyncIdChange) = rememberPreference(DataSyncIdKey, "")

    val isLoggedIn = remember(innerTubeCookie) {
        "SAPISID" in parseCookieString(innerTubeCookie)
    }
    val (useLoginForBrowse, onUseLoginForBrowseChange) = rememberPreference(UseLoginForBrowse, true)
    val (ytmSync, onYtmSyncChange) = rememberPreference(YtmSyncKey, true)

    val viewModel: HomeViewModel = hiltViewModel()
    val accountName by viewModel.accountName.collectAsState()
    val accountImageUrl by viewModel.accountImageUrl.collectAsState()

    var showToken: Boolean by remember { mutableStateOf(false) }
    var showTokenEditor by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.account)) },
                navigationIcon = {
                    IconButton(
                        onClick = navController::navigateUp,
                        onLongClick = navController::backToMain
                    ) {
                        Icon(
                            painterResource(R.drawable.arrow_back),
                            contentDescription = null
                        )
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .padding(paddingValues)
                .windowInsetsPadding(
                    LocalPlayerAwareWindowInsets.current.only(
                        WindowInsetsSides.Horizontal + WindowInsetsSides.Bottom
                    )
                )
                .verticalScroll(rememberScrollState())
        ) {

            PreferenceGroupTitle(
                title = stringResource(R.string.google),
            )

            PreferenceEntry(
                title = {
                    Text(
                        text = if (isLoggedIn)
                            accountName
                        else
                            stringResource(R.string.login)
                    )
                },
                description = if (isLoggedIn) {
                    accountEmail.takeIf { it.isNotEmpty() }
                        ?: accountChannelHandle.takeIf { it.isNotEmpty() }
                } else null,
                icon = {
                    if (isLoggedIn && accountImageUrl != null) {
                        AsyncImage(
                            model = accountImageUrl,
                            contentDescription = null,
                            contentScale = ContentScale.Crop,
                            modifier = Modifier
                                .size(24.dp)
                                .clip(CircleShape)
                        )
                    } else {
                        Icon(
                            painterResource(R.drawable.login),
                            contentDescription = null,
                            modifier = Modifier.size(24.dp)
                        )
                    }
                },
                trailingContent = {
                    if (isLoggedIn) {
                        OutlinedButton(onClick = {
                            onInnerTubeCookieChange("")
                            forgetAccount(context)
                        }) {
                            Text(stringResource(R.string.action_logout))
                        }
                    }
                },
                onClick = { if (!isLoggedIn) navController.navigate("login") }
            )

            if (showTokenEditor) {
                val text =
                    "***INNERTUBE COOKIE*** =${innerTubeCookie}\n\n***VISITOR DATA*** =${visitorData}\n\n***DATASYNC ID*** =${dataSyncId}\n\n***ACCOUNT NAME*** =${accountNamePref}\n\n***ACCOUNT EMAIL*** =${accountEmail}\n\n***ACCOUNT CHANNEL HANDLE*** =${accountChannelHandle}"
                TextFieldDialog(
                    modifier = Modifier,
                    initialTextFieldValue = TextFieldValue(text),
                    onDone = { data ->
                        data.split("\n").forEach {
                            when {
                                it.startsWith("***INNERTUBE COOKIE*** =") -> onInnerTubeCookieChange(it.substringAfter("***INNERTUBE COOKIE*** ="))
                                it.startsWith("***VISITOR DATA*** =") -> onVisitorDataChange(it.substringAfter("***VISITOR DATA*** ="))
                                it.startsWith("***DATASYNC ID*** =") -> onDataSyncIdChange(it.substringAfter("***DATASYNC ID*** ="))
                                it.startsWith("***ACCOUNT NAME*** =") -> onAccountNameChange(it.substringAfter("***ACCOUNT NAME*** ="))
                                it.startsWith("***ACCOUNT EMAIL*** =") -> onAccountEmailChange(it.substringAfter("***ACCOUNT EMAIL*** ="))
                                it.startsWith("***ACCOUNT CHANNEL HANDLE*** =") -> onAccountChannelHandleChange(it.substringAfter("***ACCOUNT CHANNEL HANDLE*** ="))
                            }
                        }
                    },
                    onDismiss = { showTokenEditor = false },
                    singleLine = false,
                    maxLines = 20,
                    isInputValid = {
                        it.isNotEmpty() && try {
                            "SAPISID" in parseCookieString(it)
                        } catch (e: Exception) {
                            false
                        }
                    },
                    extraContent = {
                        InfoLabel(text = stringResource(R.string.token_adv_login_description))
                    }
                )
            }

            PreferenceEntry(
                title = {
                    if (!isLoggedIn) {
                        Text(stringResource(R.string.advanced_login))
                    } else {
                        if (showToken) {
                            Text(stringResource(R.string.token_shown))
                        } else {
                            Text(stringResource(R.string.token_hidden))
                        }
                    }
                },
                icon = { Icon(painterResource(R.drawable.token), null) },
                onClick = {
                    if (!isLoggedIn) {
                        showTokenEditor = true
                    } else {
                        if (!showToken) {
                            showToken = true
                        } else {
                            showTokenEditor = true
                        }
                    }
                },
            )

            if (isLoggedIn) {
                SwitchPreference(
                    title = { Text(stringResource(R.string.use_login_for_browse)) },
                    description = stringResource(R.string.use_login_for_browse_desc),
                    icon = { Icon(painterResource(R.drawable.person), null) },
                    checked = useLoginForBrowse,
                    onCheckedChange = {
                        YouTube.useLoginForBrowse = it
                        onUseLoginForBrowseChange(it)
                    }
                )
            }

            if (isLoggedIn) {
                SwitchPreference(
                    title = { Text(stringResource(R.string.ytm_sync)) },
                    icon = { Icon(painterResource(R.drawable.cached), null) },
                    checked = ytmSync,
                    onCheckedChange = onYtmSyncChange,
                    isEnabled = isLoggedIn
                )
            }

            PreferenceGroupTitle(
                title = stringResource(R.string.discord),
            )

            PreferenceEntry(
                title = { Text(stringResource(R.string.discord_integration)) },
                icon = { Icon(painterResource(R.drawable.discord), null) },
                onClick = { navController.navigate("settings/discord") }
            )
        }
    }
}
