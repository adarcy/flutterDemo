package com.example.myapplication

import android.content.Context
import android.os.Bundle
import android.util.AttributeSet
import android.view.InflateException
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import butterknife.ButterKnife
import butterknife.Unbinder
import com.jess.arms.base.delegate.IActivity
import com.jess.arms.integration.cache.Cache
import com.jess.arms.integration.cache.CacheType
import com.jess.arms.integration.lifecycle.ActivityLifecycleable
import com.jess.arms.mvp.IPresenter
import com.jess.arms.mvp.IView
import com.jess.arms.utils.ArmsUtils
import com.jess.arms.utils.ThirdViewUtil
import com.trello.rxlifecycle2.android.ActivityEvent
import io.reactivex.subjects.BehaviorSubject
import io.reactivex.subjects.Subject
import me.yokeyword.fragmentation.SupportActivity
import javax.inject.Inject

abstract class BaseActivity<P : IPresenter> : SupportActivity(), IActivity, ActivityLifecycleable,
    IView {
    protected val TAG = this.javaClass.simpleName
    private val mLifecycleSubject = BehaviorSubject.create<ActivityEvent>()
    private var mCache: Cache<*, *>? = null
    private var mUnbinder: Unbinder? = null
    @Inject
    @JvmField
    var mPresenter: P? = null//如果当前页面逻辑简单, Presenter 可以为 null

    @Synchronized
    override fun provideCache(): Cache<String, Any> {
        if (mCache == null) {
            mCache = ArmsUtils.obtainAppComponentFromContext(this).cacheFactory().build(CacheType.ACTIVITY_CACHE)
        }
        return mCache as Cache<String, Any>
    }

    override fun provideLifecycleSubject(): Subject<ActivityEvent> {
        return mLifecycleSubject
    }

    override fun onCreateView(name: String, context: Context, attrs: AttributeSet): View? {
        val view = ThirdViewUtil.convertAutoView(name,context,attrs)
        return view ?: super.onCreateView(name, context, attrs)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val layoutResId = initView(savedInstanceState)
        try {
            if (layoutResId != 0) {
                setContentView(layoutResId)
                //绑定butterknife
                mUnbinder = ButterKnife.bind(this)
            }
        } catch (e: Exception) {
            if (e is InflateException) throw e
            e.printStackTrace()
        }
        initData(savedInstanceState)
        initStatusBar()
    }

    protected fun initStatusBar() {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }
}