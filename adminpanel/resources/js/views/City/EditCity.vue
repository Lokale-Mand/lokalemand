<template>
    <div>
        <div class="page-heading">
            <div class="row">
                <div class="col-12 col-md-6 order-md-1 order-last">
                    <h3>Manage City</h3>
                </div>
                <div class="col-12 col-md-6 order-md-2 order-first">
                    <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <router-link to="/dashboard">{{ __('dashboard') }}</router-link>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                <template v-if="city.id">
                                    Edit
                                </template>
                                <template v-else>
                                    Create
                                </template>
                                City
                            </li>
                        </ol>
                    </nav>
                </div>
            </div>
            <div class="row">
                <div class="col-6 col-md-6 order-md-1 order-last">
                    <div class="card h-100">
                        <div class="card-header">
                            <h4>
                                <template v-if="city.id">Edit</template>
                                <template v-else>Create</template>
                                City
                            </h4>
                        </div>
                        <div class="card-body">
                            <form ref="my-form" @submit.prevent="saveRecord">
                                <div class="form-group">
                                    <label for="city_name">Search City</label>
                                    <GmapAutocomplete type="search" class="form-control"
                                                      placeholder="Search City on map."
                                                      @place_changed="setPlace"
                                                      :options="{ fields: ['address_components','formatted_address', 'geometry', 'name','place_id','plus_code','types'], strictBounds: false }"
                                                      id="city_name">
                                    </GmapAutocomplete>
                                    <input type="hidden" v-model="city.formatted_address">
                                    <span class="text text-primary">Search your city where you will deliver the food and to find co-ordinates.</span>
                                </div>
                                <div class="form-group">
                                    <label for="latitude">Latitude <span
                                        class="text-danger text-sm">*</span></label>
                                    <input type="text" class="form-control" name="latitude" id="latitude"
                                           v-model="city.latitude" placeholder="Enter Latitude." required readonly>
                                </div>
                                <div class="form-group">
                                    <label for="longitude">Longitude <span class="text-danger text-sm">*</span></label>
                                    <input type="text" class="form-control" name="longitude" id="longitude"
                                           v-model="city.longitude" placeholder="Enter Longitude." required readonly>
                                </div>

                                <div class="form-group">
                                    <label for="name">City Name <span
                                        class="text-danger text-sm">*</span></label>
                                    <input type="text" class="form-control" name="name" id="name"
                                           v-model="city.name" placeholder="Enter City Name." required readonly>
                                </div>

                                <div class="form-group">
                                    <label for="state">State Name <span
                                        class="text-danger text-sm">*</span></label>
                                    <input type="text" class="form-control" name="state" id="state"
                                           v-model="city.state" placeholder="Enter State Name." required readonly>
                                </div>

                                <div class="form-group">
                                    <!-- take time per kilometer because we have calculated distance in km -->
                                    <label for="time_to_travel">Time to travel 1 (km) <span
                                        class="text-danger text-sm">*</span> <small>(Enter in minutes)</small>
                                    </label>
                                    <input type="number" class="form-control" name="time_to_travel"
                                           id="time_to_travel" min="0" v-model="city.time_to_travel"
                                           placeholder="Enter Time to travel 1 (km)." required>
                                </div>


                                <div class="form-group">
                                    <label for="min_amount_for_free_delivery">Minimum Amount for Free Delivery<span
                                        class="text-danger text-xs">*</span> <small>[ {{ $currency }} ]</small></label>
                                    <input type="number" class="form-control" name="min_amount_for_free_delivery"
                                           id="min_amount_for_free_delivery" v-model="city.min_amount_for_free_delivery"
                                           placeholder="Enter Delivarable Maximum Distance in km" min="0" required>
                                </div>

                                <div class="form-group">
                                    <label for="max_deliverable_distance"> Maximum Delivarable Distance<span
                                        class="text-danger text-xs">*</span> <small>[Kilometre]</small></label>
                                    <input type="number" class="form-control" name="max_deliverable_distance"
                                           id="max_deliverable_distance" v-model="city.max_deliverable_distance"
                                           placeholder="Enter Delivarable Maximum Distance in km" min="0" required>
                                </div>

                                <div class="form-group">
                                    <label for="delivery_charge_method" class=" col-12 col-form-label">Delivery Charge
                                        Methods <span class="text-danger text-sm">*</span></label>
                                    <select class="form-control form-select" name="delivery_charge_method"
                                            id="delivery_charge_method" v-model="city.delivery_charge_method" required>
                                        <option value="">Select Method</option>
                                        <option value="fixed_charge">Fixed Delivery Charges</option>
                                        <option value="per_km_charge">Per KM Delivery Charges</option>
                                        <option value="range_wise_charges">Range Wise Delivery Charges</option>
                                    </select>
                                </div>
                                <div class="form-group" v-if="city.delivery_charge_method === 'fixed_charge'">
                                    <label for="fixed_charge">Fixed Delivery Charges <span
                                        class="text-danger text-sm">*</span></label>
                                    <input type="number" class="form-control" name="fixed_charge" id="fixed_charge"
                                           v-model="city.fixed_charge" placeholder="Global Flat Charges" min="0">
                                </div>
                                <div class="form-group" v-if="city.delivery_charge_method === 'per_km_charge'">
                                    <label for="per_km_charge">Per KM Delivery Charges <span
                                        class="text-danger text-sm">*</span> </label>
                                    <input type="number" class="form-control" name="per_km_charge" id="per_km_charge"
                                           v-model="city.per_km_charge" placeholder="Per Kilometer Delivery Charge"
                                           min="0">
                                </div>
                                <div class="form-group col-sm-12"
                                     v-if="city.delivery_charge_method === 'range_wise_charges'">
                                    <label>Range Wise Delivery Charges <span class="text-danger text-sm">* </span> <span
                                        class="text-secondary text-sm">(Set Proper ranges for delivery charge. Do not repeat the range value to next range. For e.g. 1-3,4-6)</span>
                                    </label>
                                    <div class="form-group row" v-for="(range, index) in city.range_wise_charges"
                                         :key="key = index+1">
                                        <div class="col-sm-1">{{ key }}.</div>
                                        <div class="col-sm-3">
                                            <input type="number" class="form-control" name="from_range[]"
                                                   id="from_range" v-model="range.from_range" placeholder="From Range"
                                                   min="0">
                                        </div>
                                        <div class="col-sm-1 btn btn-secondary">To</div>
                                        <div class="col-sm-3">
                                            <input type="number" class="form-control" name="to_range[]" id="to_range"
                                                   v-model="range.to_range" @focusout="checkMaximumDistance()" placeholder="To Range" min="0">
                                        </div>
                                        <div class="col-sm-3">
                                            <input type="number" class="form-control" name="price[]" id="price"
                                                   v-model="range.price" placeholder="Price" min="0">
                                        </div>

                                        <div class="col-sm-1" v-if="index === 0">
                                            <a v-b-tooltip.hover title="Add Row" style="cursor: pointer;" @click="addRow">
                                                <i class="fa fa-plus-square fa-2x"></i>
                                            </a>
                                        </div>

                                        <div class="col-sm-1" v-if="index !== 0">
                                            <a v-b-tooltip.hover title="Remove Row" style="cursor: pointer;"
                                               @click="remove(index)">
                                                <i class="fa fa-times fa-2x"></i>
                                            </a>
                                        </div>

                                    </div>
<!--                                    <div class="form-group" id="range_wise_charges_input_btn">
                                        <button type="button" class="btn btn-sm btn-info ml-3" id="save_charges">Save
                                            Charges
                                        </button>
                                    </div>-->
                                </div>
                                <div class="form-group">
                                    <button type="submit" class="btn btn-primary"> {{ __('save') }}</button>
                                    <button type="reset" class="btn btn-secondary">{{ __('clear') }}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-6 order-md-1 order-last">
                    <div class="card h-100">
                        <div class="card-header">
                            <h4>Map View</h4>
                        </div>
                        <div class="card-body">
                            <div id="map" style="position: relative; overflow: hidden;">
                                <GmapMap
                                    :center="center"
                                    :zoom="13"
                                    :mapTypeControl=true
                                    style="width: 100%; height: 600px; margin-top: 20px"
                                    ref="mapRef"
                                >
                                    <GmapMarker
                                        :key="index"
                                        v-for="(m, index) in markers"
                                        :position="m.position"
                                        @click="center = m.position"
                                    />
                                    <gmap-info-window
                                        :options="{
                                                              maxWidth: 300,
                                                              pixelOffset: { width: 0, height: -35 }
                                                            }"
                                        :position="infoWindow.position"
                                        :opened="infoWindow.open"
                                        @closeclick="infoWindow.open=false">
                                        <div v-html="infoWindow.template"></div>
                                    </gmap-info-window>
                                </GmapMap>
                            </div>
                            <div v-if="city.formatted_address">
                                <span class="title font-weight-bolder">{{ city.formatted_address }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import axios from "axios";
import {gmapApi} from 'vue2-google-maps'

export default {
    data: function () {
        return {
            //center: { lat: 45.508, lng: -73.587 },
            center: {lat: 0, lng: 0},
            currentPlace: null,
            markers: [],
            city: {
                id: "",
                latitude: "",
                longitude: "",
                name: "",
                state: "",
                formatted_address: "",
                time_to_travel: "",
                min_amount_for_free_delivery: "",
                max_deliverable_distance: "",
                delivery_charge_method: "",
                fixed_charge: "",
                per_km_charge: "",
                range_wise_charges: [
                    {from_range: "", to_range: "", price: ""}
                ],
            },
            formatted_address: "",
            infoWindow: {
                position: {lat: 0, lng: 0},
                open: false,
                template: ''
            }
        }
    },
    mounted() {
        /*this.$refs.mapRef.$mapPromise.then((map) => {
            map.panTo({lat: 1.38, lng: 103.80})
        });*/
    },
    computed: {
        google: gmapApi
    },
    created: function () {
        this.city.id = this.$route.params.id;
        if (this.city.id) {
            this.getCity();
        }
    },
    methods: {
        addRow() {
            this.city.range_wise_charges.push({from_range: "", to_range: "", price: ""})
        },
        remove(index) {
            this.city.range_wise_charges.splice(index, 1)
            /*let variant_id = (this.city.range_wise_charges[index].id)?this.city.range_wise_charges[index].id:"";
            if (this.id && variant_id !== ""){
                this.$swal.fire({
                    title: "Are you Sure?",
                    text: "You want be able to revert this",
                    confirmButtonText: "Yes, Sure",
                    cancelButtonText: "Cancel",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#37a279',
                    cancelButtonColor: '#d33',
                }).then(result => {
                    if (result.value) {
                        let postData = {
                            id: variant_id
                        }
                        axios.post(this.$apiUrl + '/products/delete', postData)
                            .then((response) => {
                                let data = response.data;
                                this.inputs.splice(index, 1)
                                this.showSuccess(data.message)
                            });
                    }
                });
            } else{
                this.city.range_wise_charges.splice(index, 1)
            }*/
        },
        setPlace(place) {
            this.currentPlace = place;
            this.addMarker()
        },
        addMarker() {
            if (this.currentPlace) {
                const marker = {
                    lat: this.currentPlace.geometry.location.lat(),
                    lng: this.currentPlace.geometry.location.lng(),
                };
                this.markers.push({position: marker});
                this.center = marker;
                this.city.latitude = this.currentPlace.geometry.location.lat();
                this.city.longitude = this.currentPlace.geometry.location.lng();
                this.city.name = this.currentPlace.name;

                let addressArr = this.currentPlace.formatted_address.split(",");
                this.city.state = addressArr[addressArr.length - 2];

                this.city.formatted_address = this.currentPlace.formatted_address;
                this.infoWindow.position = {lat: this.city.latitude, lng: this.city.longitude}
                this.infoWindow.template = `<b>${this.city.name}</b><br>${this.city.formatted_address}`
                this.infoWindow.open = true;
                this.currentPlace = null;
            }
        },
        getCity() {
            this.isLoading = true
            axios.get(this.$apiUrl + '/cities/edit/' + this.city.id)
                .then((response) => {
                    this.isLoading = false
                    let data = response.data.data;
                    for (let key in this.city) {
                        if (key === 'range_wise_charges') {
                            this.city[key] = JSON.parse(data[key]);
                        } else {
                            this.city[key] = data[key];
                        }
                    }
                    const marker = {
                        lat: parseFloat(data.latitude),
                        lng: parseFloat(data.longitude)
                    };
                    this.markers.push({position: marker});
                    this.center = marker;
                    this.infoWindow.position = {lat: parseFloat(data.latitude), lng: parseFloat(data.longitude)}
                    this.infoWindow.template = `<b>${data.name}</b><br>${this.city.formatted_address}`
                    this.infoWindow.open = true;
                });
        },

        checkMaximumDistance(){

            if(this.city.delivery_charge_method === 'range_wise_charges'){
                let maxDistance = parseFloat(this.city.max_deliverable_distance);
                let charges = this.city.range_wise_charges;

                return charges.map((range, index) =>{
                    let rowNum = index+1;
                    let to_range = parseFloat(range.to_range);
                    let from_range = parseFloat(range.from_range);

                    if( to_range > maxDistance || from_range > maxDistance){
                        this.showError("Range wise delivery distance is more then maximum deliverable distance no row no. :- "+rowNum);
                        return false;
                    }
                    if(to_range <= from_range){
                        this.showError("Range wise From distance is more then To distance no row no. :- "+rowNum);
                        return false;
                    }
                });
            }
        },

        saveRecord: function () {

            if(this.checkMaximumDistance() === false){
                return false;
            }

            let vm = this;
            this.isLoading = true;
            let formObject = this.city;
            let formData = new FormData();
            for (let key in formObject) {
                if (key === 'range_wise_charges') {
                    formData.append(key, JSON.stringify(formObject[key]));
                } else {
                    formData.append(key, formObject[key]);
                }
            }
            let url = this.$apiUrl + '/cities/save';
            if (this.city.id) {
                url = this.$apiUrl + '/cities/update';
            }
            axios.post(url, formData).then(res => {
                let data = res.data;
                if (data.status === 1) {
                    //this.showSuccess(data.message);
                    this.showMessage("success", data.message);
                    setTimeout(
                        function () {
                            vm.$swal.close();
                            vm.$router.push({path: '/cities'})
                        }, 2000);
                } else {
                    vm.showError(data.message);
                    vm.isLoading = false;
                }
            }).catch(error => {
                vm.isLoading = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError("Something went wrong!");
                }
            });
        }
    }
};
</script>
