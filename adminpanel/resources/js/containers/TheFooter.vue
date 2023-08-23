<template>
<!--  <div>
    <div>
      <a href="https://coreui.io" target="_blank">CoreUI</a>
      <span class="ml-1">&copy; {{new Date().getFullYear()}} creativeLabs.</span>
    </div>
    <div class="ml-auto">
      <span class="mr-1">Powered by</span>
      <a href="https://coreui.io/vue" target="_blank">CoreUI for Vue</a>
    </div>
  </div>-->
    <footer>
        <div class="footer clearfix mb-0 text-muted">
            <div class="float-start">
<!--                <p>2021 &copy; Mazer</p>-->
<!--                <a href="javascript:void(0)" class="text-primary font-weight-normal"> @ 2022 {{ $appName }}. All Right Reserved</a>-->
                <a href="javascript:void(0)" class="text-primary font-weight-normal"> {{ $copyrightDetails }}</a>


            </div>
            <div v-if=" $currentVersion !== ''" class="float-end">
                <p>
                  Version :-
<!--                  <span class="text-danger"><i class="bi bi-heart"></i></span> by-->
                  <a href="javascript:void(0)">{{ $currentVersion }}</a>
                </p>
            </div>
        </div>
    </footer>
</template>

<script>
export default {
  name: 'TheFooter'
}
</script>
