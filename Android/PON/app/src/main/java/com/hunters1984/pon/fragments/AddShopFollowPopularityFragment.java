package com.hunters1984.pon.fragments;

import android.os.Bundle;

import com.hunters1984.pon.api.CouponAPIHelper;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.Constants;

public class AddShopFollowPopularityFragment extends BaseShopFollowFragment implements OnLoadDataListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String TYPE_ID = "TypeId";

    // TODO: Rename and change types of parameters
    private double mTypeId;


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
    public static AddShopFollowPopularityFragment newInstance(double typeId) {
        AddShopFollowPopularityFragment fragment = new AddShopFollowPopularityFragment();
        Bundle args = new Bundle();
        args.putDouble(TYPE_ID, typeId);

        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mTypeId = getArguments().getDouble(TYPE_ID);
        }

        mDataListener = this;
    }

    @Override
    public void onLoadData() {
        new CouponAPIHelper().getShopFollowCouponType(getActivity(), Constants.TYPE_POPULARITY_COUPON, mTypeId, "1", mHanlderShopFollow);
//        mLstShopFollows = new ArrayList<>();

//        for(int i=0; i<8;i++){
//            ShopModel shop =new ShopModel();
//            shop.setmIsShopFollow(0);
//            mListShops.add(shop);
//        }
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
