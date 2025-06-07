package com.elythra.music.utils

import android.util.Log
import com.elythra.music.BuildConfig
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class TestingLogger @Inject constructor() {
    
    private val dateFormat = SimpleDateFormat("HH:mm:ss.SSS", Locale.getDefault())
    private val scope = CoroutineScope(Dispatchers.IO)
    
    companion object {
        private const val TAG = "ElythraTestingMode"
        private const val USER_ACTION_TAG = "UserAction"
        private const val PERFORMANCE_TAG = "Performance"
        private const val NETWORK_TAG = "Network"
        private const val AUDIO_TAG = "Audio"
        private const val UI_TAG = "UI"
    }
    
    // User Action Logging
    fun logUserAction(
        screen: String,
        action: String,
        target: String? = null,
        metadata: Map<String, Any>? = null
    ) {
        if (!BuildConfig.ENABLE_USER_ACTION_LOGGING) return
        
        val timestamp = dateFormat.format(Date())
        val targetInfo = target?.let { " -> $it" } ?: ""
        val metadataInfo = metadata?.let { " | ${it.entries.joinToString(", ") { "${it.key}=${it.value}" }}" } ?: ""
        
        Log.i(USER_ACTION_TAG, "[$timestamp] $screen: $action$targetInfo$metadataInfo")
    }
    
    // Performance Monitoring
    fun logPerformance(
        operation: String,
        duration: Long,
        success: Boolean = true,
        metadata: Map<String, Any>? = null
    ) {
        if (!BuildConfig.ENABLE_PERFORMANCE_MONITORING) return
        
        val timestamp = dateFormat.format(Date())
        val status = if (success) "SUCCESS" else "FAILED"
        val metadataInfo = metadata?.let { " | ${it.entries.joinToString(", ") { "${it.key}=${it.value}" }}" } ?: ""
        
        Log.i(PERFORMANCE_TAG, "[$timestamp] $operation: ${duration}ms [$status]$metadataInfo")
    }
    
    // Network Logging
    fun logNetworkRequest(
        url: String,
        method: String,
        responseCode: Int? = null,
        duration: Long? = null,
        error: String? = null
    ) {
        if (!BuildConfig.ENABLE_NETWORK_LOGGING) return
        
        val timestamp = dateFormat.format(Date())
        val durationInfo = duration?.let { " (${it}ms)" } ?: ""
        val responseInfo = responseCode?.let { " -> $it" } ?: ""
        val errorInfo = error?.let { " ERROR: $it" } ?: ""
        
        Log.i(NETWORK_TAG, "[$timestamp] $method $url$responseInfo$durationInfo$errorInfo")
    }
    
    // Audio Events
    fun logAudioEvent(
        event: String,
        trackInfo: String? = null,
        position: Long? = null,
        metadata: Map<String, Any>? = null
    ) {
        val timestamp = dateFormat.format(Date())
        val trackDetails = trackInfo?.let { " | Track: $it" } ?: ""
        val positionInfo = position?.let { " | Position: ${it}ms" } ?: ""
        val metadataInfo = metadata?.let { " | ${it.entries.joinToString(", ") { "${it.key}=${it.value}" }}" } ?: ""
        
        Log.i(AUDIO_TAG, "[$timestamp] $event$trackDetails$positionInfo$metadataInfo")
    }
    
    // UI Events
    fun logUIEvent(
        screen: String,
        event: String,
        component: String? = null,
        metadata: Map<String, Any>? = null
    ) {
        val timestamp = dateFormat.format(Date())
        val componentInfo = component?.let { " | Component: $it" } ?: ""
        val metadataInfo = metadata?.let { " | ${it.entries.joinToString(", ") { "${it.key}=${it.value}" }}" } ?: ""
        
        Log.i(UI_TAG, "[$timestamp] $screen: $event$componentInfo$metadataInfo")
    }
    
    // Screen Navigation
    fun logScreenNavigation(
        from: String,
        to: String,
        trigger: String? = null,
        metadata: Map<String, Any>? = null
    ) {
        val timestamp = dateFormat.format(Date())
        val triggerInfo = trigger?.let { " | Trigger: $it" } ?: ""
        val metadataInfo = metadata?.let { " | ${it.entries.joinToString(", ") { "${it.key}=${it.value}" }}" } ?: ""
        
        Log.i(TAG, "[$timestamp] NAVIGATION: $from -> $to$triggerInfo$metadataInfo")
    }
    
    // Error Logging
    fun logError(
        context: String,
        error: Throwable,
        metadata: Map<String, Any>? = null
    ) {
        val timestamp = dateFormat.format(Date())
        val metadataInfo = metadata?.let { " | ${it.entries.joinToString(", ") { "${it.key}=${it.value}" }}" } ?: ""
        
        Log.e(TAG, "[$timestamp] ERROR in $context$metadataInfo", error)
    }
    
    // Session Events
    fun logSessionEvent(
        event: String,
        metadata: Map<String, Any>? = null
    ) {
        val timestamp = dateFormat.format(Date())
        val metadataInfo = metadata?.let { " | ${it.entries.joinToString(", ") { "${it.key}=${it.value}" }}" } ?: ""
        
        Log.i(TAG, "[$timestamp] SESSION: $event$metadataInfo")
    }
    
    // Memory and Performance Monitoring
    fun logMemoryUsage() {
        if (!BuildConfig.ENABLE_PERFORMANCE_MONITORING) return
        
        scope.launch {
            val runtime = Runtime.getRuntime()
            val usedMemory = runtime.totalMemory() - runtime.freeMemory()
            val maxMemory = runtime.maxMemory()
            val memoryPercent = (usedMemory * 100 / maxMemory)
            
            val timestamp = dateFormat.format(Date())
            Log.i(PERFORMANCE_TAG, "[$timestamp] MEMORY: ${usedMemory / 1024 / 1024}MB / ${maxMemory / 1024 / 1024}MB ($memoryPercent%)")
        }
    }
    
    // Batch logging for complex operations
    fun logBatchOperation(
        operation: String,
        items: List<String>,
        duration: Long,
        success: Boolean = true
    ) {
        val timestamp = dateFormat.format(Date())
        val status = if (success) "SUCCESS" else "FAILED"
        
        Log.i(TAG, "[$timestamp] BATCH $operation: ${items.size} items in ${duration}ms [$status]")
        items.forEachIndexed { index, item ->
            Log.v(TAG, "  [$index] $item")
        }
    }
}

// Extension functions for easy logging
fun Any.logUserAction(screen: String, action: String, target: String? = null, metadata: Map<String, Any>? = null) {
    // This would be injected in real usage, but for simplicity:
    if (BuildConfig.ENABLE_USER_ACTION_LOGGING) {
        val timestamp = SimpleDateFormat("HH:mm:ss.SSS", Locale.getDefault()).format(Date())
        val targetInfo = target?.let { " -> $it" } ?: ""
        val metadataInfo = metadata?.let { " | ${it.entries.joinToString(", ") { "${it.key}=${it.value}" }}" } ?: ""
        Log.i("UserAction", "[$timestamp] $screen: $action$targetInfo$metadataInfo")
    }
}

fun Any.logPerformance(operation: String, duration: Long, success: Boolean = true) {
    if (BuildConfig.ENABLE_PERFORMANCE_MONITORING) {
        val timestamp = SimpleDateFormat("HH:mm:ss.SSS", Locale.getDefault()).format(Date())
        val status = if (success) "SUCCESS" else "FAILED"
        Log.i("Performance", "[$timestamp] $operation: ${duration}ms [$status]")
    }
}