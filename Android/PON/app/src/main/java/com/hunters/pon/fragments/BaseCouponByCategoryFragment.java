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
import com.hunters.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseCouponByCategory;
import com.hunters.pon.api.ResponseCouponByCategoryData;
import com.hunters.pon.customs.EndlessRecyclerViewScrollListener;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.protocols.OnLoadMoreListener;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;

import java.util.List;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link BaseCouponByCategoryFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link BaseCouponByCategoryFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class BaseCouponByCategoryFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;
    protected OnLoadDataListener mDataListener;
    private CouponRecyclerViewAdapter mAdapterCouponByCategory;

    protected List<CouponModel> mListCoupons;
    private EndlessRecyclerViewScrollListener mScrollLoadMoreData;
    private int mPageTotal;
    protected OnLoadMoreListener mLoadMoreData;

    public BaseCouponByCategoryFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment BaseCouponByCategoryFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static BaseCouponByCategoryFragment newInstance(String param1, String param2) {
        BaseCouponByCategoryFragment fragment = new BaseCouponByCategoryFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        if(mDataListener != null) {
            mDataListener.onLoadData();
        }

        View view = inflater.inflate(R.layout.fragment_shop_coupons_grid_view, container, false);
        RecyclerView rv = (RecyclerView)view.findViewById(R.id.recycler_view_shop_coupon_filter);
        GridLayoutManager layoutManager = new GridLayoutManager(view.getContext(), 2);
        rv.setLayoutManager(layoutManager);

        mScrollLoadMoreData = new EndlessRecyclerViewScrollListener(layoutManager) {
            @Override
            public void onLoadMore(int page, int totalItemsCount) {
                if(page < mPageTotal) {
                    mListCoupons.add(null);
                    mAdapterCouponByCategory.notifyItemInserted(mListCoupons.size() - 1);
                    if(mLoadMoreData != null) {
                        mLoadMoreData.onLoadMoreData(page);
                    }
                }
            }
        };

        layoutManager.setSpanSizeLookup(new GridLayoutManager.SpanSizeLookup() {
            @Override
            public int getSpanSize(int position) {
                switch(mAdapterCouponByCategory.getItemViewType(position)){
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

        mAdapterCouponByCategory = new CouponRecyclerViewAdapter(view.getContext(), mListCoupons);
        rv.setAdapter(mAdapterCouponByCategory);
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
     * <p>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }

    protected Handler mHanlderGetCouponByCategory = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if(mListCoupons.size() > 0 && mListCoupons.get(mListCoupons.size() - 1) == null) {
                mListCoupons.remove(mListCoupons.size() - 1);
                mAdapterCouponByCategory.notifyItemRemoved(mListCoupons.size());
            }
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCouponByCategoryData couponByCategoryData = (ResponseCouponByCategoryData) msg.obj;
                    if (couponByCategoryData.code == APIConstants.REQUEST_OK && couponByCategoryData.httpCode == APIConstants.HTTP_OK) {
                        mPageTotal = couponByCategoryData.pagination.getmPageTotal();
                        ResponseCouponByCategory couponByCategory = couponByCategoryData.data;
                        mListCoupons.addAll(couponByCategory.getmLstCoupons());
                        mAdapterCouponByCategory.updateData(mListCoupons);
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
}
