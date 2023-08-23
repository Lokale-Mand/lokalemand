@extends('layouts.mail')
@section('content')
   {{--{{ logger('mail layout'.$type) }}--}}
        @if(isset($type))
            @include('mail/'.$type)
        @endif
        {{--@include('mail/seller_status')--}}
@endsection
