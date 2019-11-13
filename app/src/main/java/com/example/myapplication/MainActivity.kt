package com.example.myapplication

import android.os.Bundle
import android.os.PersistableBundle
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

import io.flutter.facade.Flutter
import io.flutter.view.FlutterMain
import io.flutter.view.FlutterView
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    var createView : FlutterView? = null

    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
//        window.decorView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN)
        supportActionBar?.hide()
        setContentView(R.layout.activity_main)

//        val bt_flutter = findViewById<TextView>(R.id.bt_flutter)
//        val flutter_container = findViewById<FrameLayout>(R.id.flutter_container)

        bt_flutter.text = "go_flutter"

        FlutterMain.startInitialization(this)
        bt_flutter.setOnClickListener {
//            createView = Flutter.createView(this@MainActivity, lifecycle, "route1")
//            val params = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
//            flutter_container.addView(createView, params)
        }

        createView = Flutter.createView(this@MainActivity, lifecycle, "route1")
        val params = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        flutter_container.addView(createView, params)

            //            Toast.makeText(this,"dianji",Toast.LENGTH_SHORT).show()

            //            flutter_container.autofill(createView)

    }

    override fun onBackPressed() {
        if (createView != null){
            createView?.popRoute();
        }else{
            super.onBackPressed()
        }
    }
}
