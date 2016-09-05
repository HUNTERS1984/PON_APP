package com.hunters1984.pon.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;

import com.hunters1984.pon.models.ShopModel;

import java.util.ArrayList;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link NearestShopSubscribeFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link NearestShopSubscribeFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class NearestShopSubscribeFragment extends BaseShopSubscribeFragment implements BaseShopSubscribeFragment.OnLoadDataListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    public NearestShopSubscribeFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment NearestShopSubscribeFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static NearestShopSubscribeFragment newInstance(String param1, String param2) {
        NearestShopSubscribeFragment fragment = new NearestShopSubscribeFragment();
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
        mDataListener = this;
    }

//    @Override
//    public View onCreateView(LayoutInflater inflater, ViewGroup container,
//                             Bundle savedInstanceState) {
//        View view = inflater.inflate(R.layout.fragment_nearest_shop_subscribe, container, false);
//        RecyclerView rv = (RecyclerView)view.findViewById(R.id.recycler_view_shop_subscribe);
//        rv.setLayoutManager(new GridLayoutManager(view.getContext(), 2));
//
//        ShopSubscribeDetailRecyclerViewAdapter adapter = new ShopSubscribeDetailRecyclerViewAdapter(view.getContext(), mListShops);
//        rv.setAdapter(adapter);
//        return view;
//    }

    @Override
    public void onLoadData() {
        mListShops = new ArrayList<>();

        for(int i=0; i<2;i++){
            ShopModel shop =new ShopModel();
            shop.setmIsShopSubscribe(false);
            mListShops.add(shop);
        }
    }

}
