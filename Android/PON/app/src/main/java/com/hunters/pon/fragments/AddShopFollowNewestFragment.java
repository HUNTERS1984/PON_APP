package com.hunters.pon.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;

import com.hunters.pon.api.ShopAPIHelper;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.protocols.OnLoadMoreListener;
import com.hunters.pon.utils.Constants;

import java.util.ArrayList;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link AddShopFollowNewestFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link AddShopFollowNewestFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class AddShopFollowNewestFragment extends BaseShopFollowFragment implements OnLoadDataListener, OnLoadMoreListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String CAT_ID = "CatId";

    // TODO: Rename and change types of parameters
    private long mCatId;

    public AddShopFollowNewestFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment AddShopFollowNewestFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static AddShopFollowNewestFragment newInstance(long catId) {
        AddShopFollowNewestFragment fragment = new AddShopFollowNewestFragment();
        Bundle args = new Bundle();
        args.putLong(CAT_ID, catId);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mCatId = getArguments().getLong(CAT_ID);
        }
        mDataListener = this;
        mLoadMoreData = this;
    }

//    @Override
//    public View onCreateView(LayoutInflater inflater, ViewGroup container,
//                             Bundle savedInstanceState) {
//        View view = inflater.inflate(R.layout.fragment_newest_shop_subscribe, container, false);
//        RecyclerView rv = (RecyclerView)view.findViewById(R.id.recycler_view_shop_subscribe);
//        rv.setLayoutManager(new GridLayoutManager(view.getContext(), 2));
//
//        AddShopFollowRecyclerViewAdapter adapter = new AddShopFollowRecyclerViewAdapter(view.getContext(), mListShops);
//        rv.setAdapter(adapter);
//        return view;
//    }

    @Override
    public void onLoadData() {
        mLstShopFollows = new ArrayList<>();
        new ShopAPIHelper().getShopFollowCategory(getActivity(), Constants.TYPE_NEWEST_COUPON, mCatId, "1", mHanlderShopFollow, true);
//        mListShops = new ArrayList<>();
//
//        for(int i=0; i<8;i++){
//            ShopModel shop =new ShopModel();
//            shop.setmIsShopFollow(0);
//            mListShops.add(shop);
//        }
    }


    @Override
    public void onLoadMoreData(int page) {
        new ShopAPIHelper().getShopFollowCategory(getActivity(), Constants.TYPE_NEWEST_COUPON, mCatId, String.valueOf(page + 1), mHanlderShopFollow, false);
    }
}
