@php
    $logo="";
    $app_name="";
    $support_email="";
    $support_number="";
    $google_place_api_key = "";
    $currency = "";
    $purchase_code = "";
    $logo_full_path = "";
    $delivery_boy_bonus_settings = 0;
    $isDemoMode = 0;

    $website_url = "";
    $copyright_details = "";



    // Firebase keys
    $apiKey = "";
    $authDomain = "";
    $projectId = "";
    $storageBucket = "";
    $messagingSenderId = "";
    $appId = "";
    $measurementId = "";


    if(isInstalled()){
        $app_name = \App\Models\Setting::get_value('app_name');
        if($app_name == "" || $app_name == null){
            $app_name = "eGrocer";
        }
        $support_email = \App\Models\Setting::get_value('support_email');
        if($support_email == "" || $support_email == null){
            $support_email = "";
        }
        $support_number = \App\Models\Setting::get_value('support_number');
        if($support_number == "" || $support_number == null){
            $support_number = "";
        }

        $logo = \App\Models\Setting::get_value('logo') ?? "";
        if($logo!==""){
            $logo_full_path =  url('/').'/storage/'.$logo;
        }else{
            $logo_full_path =  asset('images/favicon.png');
        }

        $google_place_api_key = \App\Models\Setting::get_value('google_place_api_key') ?? "";
        $currency = \App\Models\Setting::get_value('currency') ?? "$";
        $purchase_code = \App\Models\Setting::get_value('purchase_code') ?? "";

        $website_url = \App\Models\Setting::get_value('website_url') ?? "";
        $copyright_details = \App\Models\Setting::get_value('copyright_details') ?? "";

        $delivery_boy_bonus_settings = \App\Models\Setting::get_value('delivery_boy_bonus_settings') ?? 0;

        // Firebase keys
        $apiKey = \App\Models\Setting::get_value('apiKey') ?? "";
        $authDomain = \App\Models\Setting::get_value('authDomain') ?? "";
        $projectId = \App\Models\Setting::get_value('projectId') ?? "";
        $storageBucket = \App\Models\Setting::get_value('storageBucket') ?? "";
        $messagingSenderId = \App\Models\Setting::get_value('messagingSenderId') ?? "";
        $appId = \App\Models\Setting::get_value('appId') ?? "";
        $measurementId = \App\Models\Setting::get_value('measurementId') ?? "";
        $isDemoMode = isDemoMode() ?? 0;
    }
@endphp

<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}" />

    <title>{{ $app_name??'eGrocer' }}</title>
    <link rel="shortcut icon" href="{{ $logo_full_path }}">

<!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="{{ asset('assets/css/bootstrap.css')}}">

<!--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">-->

    <link rel="stylesheet" href="{{ asset('assets/vendors/iconly/bold.css') }}">
{{--        <link rel="stylesheet" href="{{ asset('assets/vendors/fontawesome/all.min.css') }}">--}}
    <link rel="stylesheet" href="{{ asset('assets/vendors/perfect-scrollbar/perfect-scrollbar.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/vendors/bootstrap-icons/bootstrap-icons.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/css/app.css') }}">
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/css/style.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/css/boostrap_vue.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/css/pages/form-element-select.css') }}">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <!-- Auth -->
    <link rel="stylesheet" href="{{ asset('assets/css/pages/auth.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/css/pages/error.css') }}">
    <!-- Styles -->

    <link rel="stylesheet" href="{{ asset('assets/css/custom/common.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/dark-mode/app-dark.css') }}">

    @if (isDemoMode())
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=G-CZZ7MV8RBB"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());

            gtag('config', 'G-CZZ7MV8RBB');
        </script>
    @endif

</head>
<body class="">
{{-- <script src="{{ asset('assets/dark-mode/initTheme.js') }}"></script> --}}
<div id="app">
    <router-view></router-view>
</div>

<!--You can comment this or remove these 3 lines so popup update will stop-->
@if(auth()->user() && auth()->user()->role_id==1)
    @include('vendor.laraupdater.notification')
@endif

<script src="{{ asset('assets/vendors/perfect-scrollbar/perfect-scrollbar.min.js') }}"></script>
<script src="{{ asset('assets/js/bootstrap.bundle.min.js') }}"></script>
<script src="{{ asset('assets/js/mazer.js') }}"></script>
<script src="{{ asset('assets/js/extensions/form-element-select.js') }}"></script>
<script>
    window.baseUrl = '{{ url('/') }}';
    window.appName = "{{ $app_name }}";
    window.supportEmail = "{{ $support_email }}";
    window.supportNumber = "{{ $support_number }}";
    window.MapApiKey = "{{ $google_place_api_key }}";
    window.appLogo = "{{ $logo }}";
    window.currency = "{{ $currency }}";
    window.isInstalled = "{{ isInstalled() }}";
    window.purchase_code = "{{ $purchase_code }}";

    window.websiteUrl = "{{ $website_url }}";
    window.copyrightDetails = "{{ $copyright_details }}";


    window.deliveryBoyBonusSettings = "{{ $delivery_boy_bonus_settings }}";
    window.isDemo = "{{ $isDemoMode }}";
    window.currentVersion = "{{ currentVersion() }}";

    @auth
    /* Login*/
    window.UserPermissions = {!! json_encode(Auth::user()->allPermissions, true) !!};
    window.Role = "{!! Auth::user()->role->name !!}";
    @else
    /* Not Login*/
    window.UserPermissions = [];
    window.Role = '';
    @endauth
</script>
<script src="{{ asset('js/app.js') }}"></script>
{{--<script src="{{ mix('js/app.js') }}" ></script>
<script src="{{ route('assets.lang')  }}"></script>
--}}

{{--<script src="{{ route('assets.lang')  }}"></script>--}}


@if(isInstalled())
{{--<script src="{{ route('assets.firebase-messaging-sw')  }}"></script>--}}
@endif
<!--Web Push-->
<!-- The core Firebase JS SDK is always required and must be listed first -->
<script src="https://www.gstatic.com/firebasejs/8.3.2/firebase.js"></script>

@php

    $lang = config('app.locale');
    $lang = $lang ?? 'en';
    // \Log::info("lang file ".$lang);
    $file =  file_get_contents(resource_path('lang/' . $lang . '.json'));

@endphp

<!--php artisan cache:clear
php artisan route:clear
php artisan config:clear
php artisan view:clear-->

<script>

    let lang = JSON.stringify(<?php  echo $file; ?>);
    localStorage.setItem('language', lang);


    @if($apiKey!='' && $authDomain!='' && $authDomain!='' && $projectId!='' && $storageBucket!='' && $messagingSenderId!='' && $appId!='' && $measurementId!='')

        var firebaseConfig = {
            apiKey: "{{ $apiKey }}",
            authDomain: "{{ $authDomain }}",
            projectId: "{{ $projectId }}",
            storageBucket: "{{ $storageBucket }}",
            messagingSenderId: "{{ $messagingSenderId }}",
            appId: "{{ $appId }}",
            measurementId: "{{ $measurementId }}"
        };

        var firebaseCheck =  firebase.initializeApp(firebaseConfig);

        /*console.log("option => ", firebaseCheck.options.messagingSenderId);
        console.log("firebaseCheck => ", firebaseCheck);*/

        if ('Notification' in window) {

            if (firebase.messaging.isSupported()) {
                console.log("Notification 2");
                const messaging = firebase.messaging();
                startFCM();

                function startFCM() {
                    messaging
                        .requestPermission()
                        .then(function () {
                            return messaging.getToken()
                        })
                        .then(function (response) {
                            $.ajaxSetup({
                                headers: {
                                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                                }
                            });
                            $.ajax({
                                url: '{{ route("fcmToken") }}',
                                type: 'POST',
                                data: {
                                    token: response
                                },
                                dataType: 'JSON',
                                success: function (response) {
                                    //alert('Token stored.');
                                },
                                error: function (error) {
                                    //alert(error);
                                },
                            });
                        }).catch(function (error) {
                        //alert(error);
                    });
                }

                messaging.onMessage(function (payload) {
                    //console.log("onMessage : ",payload);
                    //const notification = payload.notification;
                    const notification = JSON.parse(payload.data.data);

                    //prevent notification on other tabs
                    if (document.hidden) {
                        return false;
                    }

                    const title = notification.title;
                    const options = {
                        body: notification.body,
                        icon: notification.icon,
                    };
                    new Notification(title, options);
                });
            }
        }

    @endif
</script>

{{-- <script>
    const hasDarkPreference = window.matchMedia(
        "(prefers-color-scheme: dark)"
    ).matches;
    let theme;
    if (hasDarkPreference) {
        theme = "theme-dark";
    } else {
        theme = "theme-light";
    }
    document.body.className = theme;
    sessionStorage.setItem("user-theme", theme);
</script>--}}

</body>
</html>
