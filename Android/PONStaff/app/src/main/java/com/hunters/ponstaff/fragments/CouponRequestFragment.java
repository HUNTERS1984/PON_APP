package com.hunters.ponstaff.fragments;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.hunters.ponstaff.R;
import com.hunters.ponstaff.adapters.CouponRequestRecyclerViewAdapter;
import com.hunters.ponstaff.adapters.DividerItemDecoration;
import com.hunters.ponstaff.customs.EndlessRecyclerViewScrollListener;
import com.hunters.ponstaff.models.CouponRequestModel;

import java.util.ArrayList;
import java.util.List;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link CouponRequestFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link CouponRequestFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class CouponRequestFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    private Context mContext;
    private CouponRequestRecyclerViewAdapter mCouponRequestAdapter;
    private List<CouponRequestModel> mLstCouponRequests;
    private EndlessRecyclerViewScrollListener mScrollLoadMoreData;
    private int mPageTotal;

    public CouponRequestFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment CouponRequestFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static CouponRequestFragment newInstance(String param1, String param2) {
        CouponRequestFragment fragment = new CouponRequestFragment();
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
        mContext = getActivity();
        initData();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view =  inflater.inflate(R.layout.fragment_coupon_request, container, false);

        RecyclerView rv = (RecyclerView)view.findViewById(R.id.recycler_view_coupon_request);
        LinearLayoutManager layoutManager = new LinearLayoutManager(mContext);
        rv.setLayoutManager(layoutManager);

        rv.addItemDecoration(new DividerItemDecoration(mContext, LinearLayoutManager.VERTICAL));
        rv.setItemAnimator(new DefaultItemAnimator());

        mCouponRequestAdapter = new CouponRequestRecyclerViewAdapter(mContext, mLstCouponRequests);
        rv.setAdapter(mCouponRequestAdapter);

        mScrollLoadMoreData = new EndlessRecyclerViewScrollListener(layoutManager) {
            @Override
            public void onLoadMore(int page, int totalItemsCount) {
                if(page < mPageTotal) {
//                    mLstCouponRequests.add(null);
//                    mAdapterCategory.notifyItemInserted(mLstCategories.size() - 1);
//                    new CouponAPIHelper().getCategory(mContext, String.valueOf(page + 1), mHanlderGetCategory, false);
                }
            }
        };
        rv.addOnScrollListener(mScrollLoadMoreData);

        return view;
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

    private void initData()
    {
        mLstCouponRequests = new ArrayList<>();
        for(int i=0; i< 10; i++) {
            CouponRequestModel model = new CouponRequestModel();
            model.setmTitle("Joel Rivera");
            model.setmDes("Sale 40% Beer");
            model.setmTimeRequest("1 minute ago");
            mLstCouponRequests.add(model);
        }
    }
}
