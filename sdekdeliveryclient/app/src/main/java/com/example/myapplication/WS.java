package com.example.myapplication;

import android.util.Log;
import okhttp3.Response;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;
import okio.ByteString;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.nio.charset.StandardCharsets;

public class WS extends WebSocketListener {
    @Override
    public void onOpen(@NotNull WebSocket webSocket, @NotNull Response response) {
        Log.i("WebSocket", "websocket opened");
    }

    @Override
    public void onMessage(@NotNull WebSocket webSocket, @NotNull String text) {
        Log.i("WebSocket", "message received: " + text);
    }

    @Override
    public void onMessage(@NotNull WebSocket webSocket, @NotNull ByteString bytes) {
        Log.i("WebSocket", "message received: " + bytes.string(StandardCharsets.UTF_8));
    }

    @Override
    public void onClosing(@NotNull WebSocket webSocket, int code, @NotNull String reason) {
        Log.i("WebSocket", "websocket closed");
    }

    @Override
    public void onFailure(@NotNull WebSocket webSocket, @NotNull Throwable t, @Nullable Response response) {
        Log.e("WebSocket", "websocket error", t);
    }
}
