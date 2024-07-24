package com.spagreen.linphonesdk;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.nfc.FormatException;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

public class Utils {
    private final String TAG = Utils.class.getSimpleName();
   public boolean checkPermissions(String[] permissions, Activity activity) {
      try {
         int result;
         List<String> listPermissionsNeeded = new ArrayList<>();
         for (String p : permissions) {
            result = ContextCompat.checkSelfPermission(activity, p);
            if (result != PackageManager.PERMISSION_GRANTED) {
               listPermissionsNeeded.add(p);
            }
         }
         if (!listPermissionsNeeded.isEmpty()) {
            ActivityCompat.requestPermissions(activity, listPermissionsNeeded.toArray(new String[listPermissionsNeeded.size()]), 1111);
            return false;
         }
      }catch (Exception e){
         e.printStackTrace();
      }

      return true;
   }
}
