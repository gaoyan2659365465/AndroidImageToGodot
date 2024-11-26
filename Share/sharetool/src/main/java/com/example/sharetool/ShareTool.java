package com.example.sharetool;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.view.View;

import androidx.annotation.NonNull;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;
import org.godotengine.godot.plugin.UsedByGodot;

import java.util.HashSet;
import java.util.Set;

public class ShareTool extends GodotPlugin {

    public SignalInfo share = new SignalInfo("share",String.class);
    public ShareTool(Godot godot){
        super(godot);
    }

    @NonNull
    public String getPluginName(){
        return "ShareTool";
    }

    @NonNull
    @Override
    public Set<SignalInfo> getPluginSignals(){
        HashSet<SignalInfo> signals = new HashSet<>();
        signals.add(share);
        return signals;
    }


    @UsedByGodot
    public String getHelloWorld(){
        emitSignal(share.getName(),"Hello Share Tool");
        return "Hello Share Tool";
    }

    public void shareEmit(String value){
        emitSignal(share.getName(),value);
    }

}
