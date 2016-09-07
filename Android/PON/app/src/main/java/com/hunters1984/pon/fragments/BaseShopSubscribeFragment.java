package com.hunters1984.pon.fragments;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.ShopSubscribeDetailRecyclerViewAdapter;
import com.hunters1984.pon.interfaces.OnLoadDataListener;
import com.hunters1984.pon.models.ShopModel;

import java.util.List;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link BaseShopSubscribeFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link BaseShopSubscribeFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class BaseShopSubscribeFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    protected OnLoadDataListener mDataListener;

    protected List<ShopModel> mListShops;

    public BaseShopSubscribeFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment BaseShopSubscribeFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static BaseShopSubscribeFragment newInstance(String param1, String param2) {
        BaseShopSubscribeFragment fragment = new BaseShopSubscribeFragment();
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
        rv.setLayoutManager(new GridLayoutManager(view.getContext(), 2));

        ShopSubscribeDetailRecyclerViewAdapter adapter = new ShopSubscribeDetailRecyclerViewAdapter(view.getContext(), mListShops);
        rv.setAdapter(adapter);

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
}
