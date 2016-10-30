package com.hunters.pon.fragments;

import android.os.Bundle;

import com.hunters.pon.api.ShopAPIHelper;
import com.hunters.pon.models.ShopModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.protocols.OnLoadMoreListener;
import com.hunters.pon.utils.Constants;

import java.util.ArrayList;

public class AddShopFollowPopularityFragment extends BaseShopFollowFragment implements OnLoadDataListener, OnLoadMoreListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String CAT_ID = "CatId";

    // TODO: Rename and change types of parameters
    private long mCatId;


    public AddShopFollowPopularityFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment AddShopFollowPopularityFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static AddShopFollowPopularityFragment newInstance(long catId) {
        AddShopFollowPopularityFragment fragment = new AddShopFollowPopularityFragment();
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

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onLoadData() {
        mLstShopFollows = new ArrayList<>();
        new ShopAPIHelper().getShopFollowCategory(getActivity(), Constants.TYPE_POPULARITY_COUPON, mCatId, "", "", "1", mHanlderShopFollow, true);
    }

    @Override
    public void updateStatusFollowShop(int position)
    {
        if(mLstShopFollows != null) {
            ShopModel shop = mLstShopFollows.get(position);
            boolean isShopFollow = shop.getmIsShopFollow();
            mLstShopFollows.get(position).setmIsShopFollow(!isShopFollow);
            mAdapterShopFollow.notifyDataSetChanged();
        }
    }

    @Override
    public void onLoadMoreData(int page) {
        new ShopAPIHelper().getShopFollowCategory(getActivity(), Constants.TYPE_POPULARITY_COUPON, mCatId, "", "", String.valueOf(page + 1), mHanlderShopFollow, false);

    }

//    @Override
//    public View onCreateView(LayoutInflater inflater, ViewGroup container,
//                             Bundle savedInstanceState) {
//        View view = inflater.inflate(R.layout.fragment_shop_subscribe_coupon, container, false);
//        RecyclerView rv = (RecyclerView)view.findViewById(R.id.recycler_view_shop_subscribe);
//        rv.setLayoutManager(new GridLayoutManager(view.getContext(), 2));
//
//        AddShopFollowRecyclerViewAdapter adapter = new AddShopFollowRecyclerViewAdapter(view.getContext(), mListShops);
//        rv.setAdapter(adapter);
//        return view;
//    }
}
