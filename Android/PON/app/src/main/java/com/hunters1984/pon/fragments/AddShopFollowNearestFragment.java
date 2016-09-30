package com.hunters1984.pon.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;

import com.hunters1984.pon.api.CouponAPIHelper;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.Constants;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link AddShopFollowNearestFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link AddShopFollowNearestFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class AddShopFollowNearestFragment extends BaseShopFollowFragment implements OnLoadDataListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String TYPE_ID = "TypeId";

    // TODO: Rename and change types of parameters
    private double mTypeId;

    public AddShopFollowNearestFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment AddShopFollowNearestFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static AddShopFollowNearestFragment newInstance(double typeId) {
        AddShopFollowNearestFragment fragment = new AddShopFollowNearestFragment();
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

//    @Override
//    public View onCreateView(LayoutInflater inflater, ViewGroup container,
//                             Bundle savedInstanceState) {
//        View view = inflater.inflate(R.layout.fragment_nearest_shop_subscribe, container, false);
//        RecyclerView rv = (RecyclerView)view.findViewById(R.id.recycler_view_shop_subscribe);
//        rv.setLayoutManager(new GridLayoutManager(view.getContext(), 2));
//
//        AddShopFollowRecyclerViewAdapter adapter = new AddShopFollowRecyclerViewAdapter(view.getContext(), mListShops);
//        rv.setAdapter(adapter);
//        return view;
//    }

    @Override
    public void onLoadData() {

        new CouponAPIHelper().getShopFollowCouponType(getActivity(), Constants.TYPE_NEAREST_COUPON, mTypeId, "1", mHanlderShopFollow);
//        mListShops = new ArrayList<>();
//
//        for(int i=0; i<2;i++){
//            ShopModel shop =new ShopModel();
//            shop.setmIsShopFollow(CommonUtils.convertInt(false));
//            mListShops.add(shop);
//        }
    }

}