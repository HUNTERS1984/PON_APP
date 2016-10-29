package com.hunters.pon.fragments;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.hunters.pon.R;
import com.hunters.pon.adapters.AddShopFollowRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseShopFollowCategoryData;
import com.hunters.pon.customs.EndlessRecyclerViewScrollListener;
import com.hunters.pon.models.ShopModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.protocols.OnLoadMoreListener;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.ProgressDialogUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link BaseShopFollowFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link BaseShopFollowFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public abstract class BaseShopFollowFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    protected OnLoadDataListener mDataListener;

//    protected List<ShopModel> mLstShopFollows;

    protected AddShopFollowRecyclerViewAdapter mAdapterShopFollow;

    private EndlessRecyclerViewScrollListener mScrollLoadMoreData;
    private int mPageTotal;
    protected OnLoadMoreListener mLoadMoreData;

    protected List<ShopModel> mLstShopFollows;
    protected ProgressDialogUtils mProgressDialogUtils;

    public BaseShopFollowFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }


//        initData();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        if(mDataListener != null) {
            mDataListener.onLoadData();
        }

        View view = inflater.inflate(R.layout.fragment_shop_subscribe_coupon, container, false);
        RecyclerView rv = (RecyclerView)view.findViewById(R.id.recycler_view_shop_subscribe);
        GridLayoutManager layoutManager = new GridLayoutManager(view.getContext(), 2);
        rv.setLayoutManager(layoutManager);

        mScrollLoadMoreData = new EndlessRecyclerViewScrollListener(layoutManager) {
            @Override
            public void onLoadMore(int page, int totalItemsCount) {
                if(page < mPageTotal) {
                    mLstShopFollows.add(null);
                    mAdapterShopFollow.notifyItemInserted(mLstShopFollows.size() - 1);
                    if(mLoadMoreData != null) {
                        mLoadMoreData.onLoadMoreData(page);
                    }
                }
            }
        };

        mLstShopFollows = new ArrayList<>();
        mAdapterShopFollow = new AddShopFollowRecyclerViewAdapter(view.getContext(), mLstShopFollows);
        rv.setAdapter(mAdapterShopFollow);

        layoutManager.setSpanSizeLookup(new GridLayoutManager.SpanSizeLookup() {
            @Override
            public int getSpanSize(int position) {
                switch(mAdapterShopFollow.getItemViewType(position)){
                    case Constants.VIEW_TYPE_ITEM:
                        return 1;
                    case Constants.VIEW_TYPE_LOADING:
                        return 2; //number of columns of the grid
                    default:
                        return -1;
                }
            }
        });
        rv.addOnScrollListener(mScrollLoadMoreData);

        return view;
    }

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof OnFragmentInteractionListener) {
            mListener = (OnFragmentInteractionListener) context;
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }

//    public interface OnLoadDataListener {
//        void onLoadData();
//    }

//    protected void initData()
//    {
//        mListShops = new ArrayList<>();
//
//        for(int i=0; i<8;i++){
//            ShopModel shop =new ShopModel();
//            shop.setmIsShopSubscribe(false);
//            mListShops.add(shop);
//        }
//    }

    protected Handler mHanlderShopFollow = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if(mLstShopFollows.size() > 0 && mLstShopFollows.get(mLstShopFollows.size() - 1) == null) {
                mLstShopFollows.remove(mLstShopFollows.size() - 1);
                mAdapterShopFollow.notifyItemRemoved(mLstShopFollows.size());
            }
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseShopFollowCategoryData shopFollow = (ResponseShopFollowCategoryData) msg.obj;
                    if (shopFollow.code == APIConstants.REQUEST_OK && shopFollow.httpCode == APIConstants.HTTP_OK) {
                        if(shopFollow.pagination != null) {
                            mPageTotal = shopFollow.pagination.getmPageTotal();
                        }
                        if(shopFollow.data != null) {
                            mLstShopFollows.addAll(shopFollow.data);
                            mAdapterShopFollow.updateData(mLstShopFollows);
                        }
                    } else {
                        new DialogUtiils().showDialog(getActivity(), getString(R.string.server_error), false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    mScrollLoadMoreData.adjustCurrentPage();
                    new DialogUtiils().showDialog(getActivity(), getString(R.string.connection_failed), false);
                    break;
            }
            mScrollLoadMoreData.setLoaded();
        }
    };

    protected void showProgressDialog(Context context) {

        if(mProgressDialogUtils == null) {
            mProgressDialogUtils = new ProgressDialogUtils(context, "", context.getString(R.string.connecting));
        }
        mProgressDialogUtils.show();
    }

    protected void closeDialog() {
        if(mProgressDialogUtils != null){
            mProgressDialogUtils.hide();
        }
    }

    public abstract void updateStatusFollowShop(int position);
}
