<template>
    <div>
        <div class="page-heading">
            <div class="row">
                <div class="col-12 col-md-6 order-md-1 order-last">
                    <h3>View Order</h3>
                </div>
                <div class="col-12 col-md-6 order-md-2 order-first">
                    <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><router-link to="/dashboard">{{ __('dashboard') }}</router-link></li>
                            <li class="breadcrumb-item" aria-current="page"><router-link to="/orders">View Order</router-link></li>
                            <li class="breadcrumb-item active" aria-current="page">
                                Order Details
                            </li>
                        </ol>
                    </nav>
                </div>
            </div>

            <div v-if="order" class="row">
                <div class="col-md-6">
                    <div class="card h-100">
                        <div class="card-header">
                            <h4>Order Details</h4>
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <tbody>
                                    <tr>
                                        <th class="th-width">Order Id</th>
                                        <td>{{ order.order_id }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Email</th>
                                        <td>{{ order.user_email }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">O. Note</th>
                                        <td>{{ order.order_note }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Status</th>
                                        <td>
                                            {{ this.statuses.find((item) => item.id === order.active_status).status }}
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Name</th>
                                        <td>{{ order.user_name }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Contact</th>
                                        <td>{{ order.user_mobile | mobileMask }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Area</th>
                                        <td>{{ order.address }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Pincode</th>
                                        <td>{{ order.pincode }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">OTP</th>
                                        <td>{{ order.otp }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Delivery Boy</th>
                                        <td>
                                            <template v-if="order.delivery_boy_name">
                                                {{ order.delivery_boy_name }}
                                            </template>
                                            <template v-else>
                                                Not Assign
                                            </template>
                                        </td>
                                    </tr>
                                    <tr v-if="this.$roleDeliveryBoy !== this.login_user.role.name">
                                        <th class="th-width">Assign Delivery Boy</th>
                                        <td>
                                            <form class="row g-3 align-items-center" ref="my-form" @submit.prevent="assignDeliveryBoy">
<!--                                                <div class="col-9">
                                                    <label class="visually-hidden" for="delivery_boy_id">Delivery Boy</label>
                                                    <select id="delivery_boy_id" name="status" class="form-control form-select" v-model="delivery_boy_id">
                                                        <option value="">Select Delivery Boy</option>
                                                        <option v-for="boy in deliveryBoys" :value='boy.id'>{{ boy.name }}</option>
                                                    </select>
                                                </div>
                                                <div class="col-3">
                                                    <button type="submit" class="btn btn-primary" :disabled="delivery_boy_id ==='' " > Update </button>
                                                </div>-->
                                                <div class="input-group">
                                                    <label class="visually-hidden" for="delivery_boy_id">Delivery Boy</label>
                                                    <select id="delivery_boy_id" name="status" class="form-control form-select" v-model="delivery_boy_id">
                                                        <option value="">Select Delivery Boy</option>
                                                        <option v-for="boy in deliveryBoys" :value='boy.id'>{{ boy.name }}</option>
                                                    </select>
                                                    <div class="input-group-append">
                                                        <button type="submit" class="btn btn-primary" :disabled="delivery_boy_id ==='' " > Update </button>
                                                    </div>
                                                </div>

                                            </form>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Update Status</th>
                                        <td>
                                            <form class="row g-3 align-items-center" ref="my-form" @submit.prevent="updateStatus">
<!--                                                <div class="col-9">
                                                    <label class="visually-hidden" for="status">Status</label>
                                                    <select id="status" name="status" class="form-control form-select" v-model="order_status_id">
                                                        <option value="">Select Order Status</option>
                                                        <option v-for="status in statuses" :value='status.id'>{{ status.status }}</option>
                                                    </select>
                                                </div>
                                                <div class="col-3">
                                                    <button type="submit" class="btn btn-primary" :disabled="order_status_id === ''" > Update </button>
                                                </div>-->

                                                <div class="input-group">
                                                    <label class="visually-hidden" for="status">Status</label>
                                                    <select id="status" name="status" class="form-control form-select" v-model="order_status_id">
                                                        <option value="">Select Order Status</option>
                                                        <option v-for="status in statuses" :value='status.id'>{{ status.status }}</option>
                                                    </select>
                                                    <div class="input-group-append">
                                                        <button type="submit" class="btn btn-primary" :disabled="order_status_id === ''" > Update </button>
                                                    </div>
                                                </div>
                                            </form>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card h-100">
                        <div class="card-header">
                            <h4>Billing Details</h4>
                            <span class="pull-right">

                                <button @click="downloadInvoice" v-b-tooltip.hover title="Download Invoice" class="btn btn-secondary btn-sm" :disabled="isLoading" >
                                    <template v-if="isLoading" >
                                        <b-spinner small label="Spinning"></b-spinner> Downloading...
                                    </template>
                                    <template v-else>
                                        <i class="fa fa-download"></i> Download Invoice
                                    </template>
                                </button>

                                <router-link :to="{ name: 'InvoiceOrder',params: { id: order.order_id }}" v-b-tooltip.hover title="Generate Invoice" class="btn btn-primary btn-sm">
                                    <i class="fa fa-file" aria-hidden="true"></i> Generate Invoice
                                </router-link>
                            </span>
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <tbody>
                                    <tr>
                                        <th class="th-width">Order Date</th>
                                        <td>{{ order.created_at }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Address</th>
                                        <td colspan="3">{{ order.address+', '+order.landmark+', '+order.area+', '+order.city+', '+order.state+'-'+order.pincode+', '+order.country }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Delivery Time</th>
                                        <td>{{ order.delivery_time }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Total ({{ $currency }})</th>
                                        <td>{{ order.total }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Disc. {{ $currency }}( % )</th>
                                        <td>{{ discount_in_rupees+' ( '+ order.discount+'% )' }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Additional Disc {{ $currency }}( % )</th>
                                        <td>
                                            <div class="input-group">
                                                <input type="number" class="form-control" name="input_discount" :value="order.discount" min=0 max=100 placeholder="Discount %" aria-label="Discount %" aria-describedby="save">
                                                <button class="btn btn-primary" type="button" id="save">Save</button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Promo Disc. ({{ $currency }})</th>
                                        <td>{{ order.promo_discount }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Promo Code</th>
                                        <td>{{ order.promo_code }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">D.Charge ({{ $currency }})</th>
                                        <td>{{ order.delivery_charge }}</td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Payable Total( {{ $currency }} )</th>
                                        <td>
                                            <input type="number" class="form-control" name="final_total" :value="order.final_total" disabled>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="th-width">Payment Method</th>
                                        <td>{{ order.payment_method }}</td>
                                    </tr>
                            </tbody>
                        </table>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-md-12 mt-4">
                    <h4>List of Order Items</h4>
                    <div class="row">
                        <div class="col-md-4" v-for="item in order_items">
                            <div class="card">
                                <div class="card-body">
                                    <b>Name :- </b>{{ item.product_name+" ("+item.variant_name+")" }}
                                    <br>
                                    <b>Quantity :- </b>{{ item.quantity }}
                                    <br>
                                    <b>Variant :- </b>{{ item.variant_name }}
                                    <br>
                                    <b>Subtotal( {{ $currency }} ) :- </b>{{ item.sub_total }}
                                    <div class="row mt-3">
                                        <div class="col-6">
                                            <b-button v-b-tooltip.hover title="View Item Details" class="btn btn-block btn-primary"  @click="sendInfo(item)">
                                                View Item Details
                                            </b-button>
                                        </div>
                                        <div class="col-6">
                                            <router-link :to="{ name: 'ViewProduct',params: { id: item.product_id }}" v-b-tooltip.hover title="View Product" class="btn btn-block btn-light-primary">View Product</router-link>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
<!--                <table class="table table-bordered">
                    <tbody>
                    <tr>
                        <th style="width: 150px">Items</th>
                        <td colspan="3">
                            <div class="row">
                                <div class="col-md-12">
                                    <h4>Standard Shipping Order items</h4>
                                </div>
                            </div>
                            <div class="divider">
                                <div class="divider-text"><h5>List of Order Items</h5></div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 mb-4" v-for="item in order_items">
                                    <ul class="list-group">
                                        <li class="list-group-item"><b>Name :- </b>{{ item.product_name+" ("+item.variant_name+")" }}</li>
                                        <li class="list-group-item capitalize" v-if="item.active_status" >
                                            <b>Status :- </b>{{ item.active_status }}
                                        </li>
                                        <li class="list-group-item"><b>Product Id :- </b>{{ item.product_id }}
                                            <router-link :to="{ name: 'ViewProduct',params: { id: item.product_id }}" v-b-tooltip.hover title="View" class="btn btn-primary btn-sm pull-right"><i class="fa fa-eye"></i></router-link>
                                        </li>
                                        <li class="list-group-item" v-if="item.seller_name" ><b>Seller Name :- </b>{{ item.seller_name }}</li>
                                        <li class="list-group-item"><b>User Name :- </b>{{ item.user_name }}</li>
                                        <li class="list-group-item"><b>Variant Id :- </b>{{ item.product_variant_id }}</li>
                                        <li class="list-group-item"><b>Quantity :- </b>{{ item.quantity }}</li>
                                        <li class="list-group-item"><b>Price :- </b>{{ item.price }}</li>
                                        <li class="list-group-item"><b>Discounted Price( {{ $currency }} ) :- </b>{{ item.discounted_price }}</li>
                                        <li class="list-group-item"><b>Tax Amount( {{ $currency }} ) :- </b>{{ item.tax_amount }}</li>
                                        <li class="list-group-item"><b>Tax Percentage(%) :- </b>{{ item.tax_percentage }}</li>
                                        <li class="list-group-item"><b>Subtotal( {{ $currency }} ) :- </b>{{ item.sub_total }}</li>
                                        <li class="list-group-item">
                                            <a class=" col-sm-12 btn btn-success" :href="whatsappMessageLink(order.country_code,order.mobile,order.user_name,order.id, item.id)"
                                               target="_blank" title="Send Whatsapp Notification">
                                                <i class="fa fa-whatsapp"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </div>

                            </div>
                        </td>
                    </tr>

                    </tbody>
                </table>-->

<!--                <div class="col-12 col-md-12 order-md-1 order-last">
                    <div class="card">
                        <div class="card-header">
                            <h4>Order Details</h4>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <table class="table table-bordered ">
                                        <tbody>
                                        <tr>
                                            <th style="width: 150px">ID</th>
                                            <td>{{ order.order_id }}</td>
                                            <th style="width: 150px">Name</th>
                                            <td>{{ order.user_name }}</td>
                                        </tr>
                                        <tr>
                                            <th style="width: 150px">Email</th>
                                            <td>{{ order.user_email }}</td>
                                            <th style="width: 150px">Contact</th>
                                            <td>{{ order.user_mobile }}</td>
                                        </tr>
                                        <tr>
                                            <th style="width: 150px">O. Note</th>
                                            <td>{{ order.order_note }}</td>
                                            <th style="width: 150px">Area</th>
                                            <td>{{ order.address }}</td>
                                        </tr>
                                        <tr>
                                            <th style="width: 150px">Pincode</th>
                                            <td>{{ order.pincode }}</td>
                                            <th style="width: 150px">OTP</th>
                                            <td>{{ order.otp }}</td>
                                        </tr>

                                        <tr>
                                            <th style="width: 150px">Status</th>
                                            <td>{{ order.active_status }}</td>
                                            <th style="width: 150px">Update Status</th>
                                            <td colspan="3">
                                                <form class="row g-3 align-items-center" ref="my-form" @submit.prevent="updateStatus">
                                                    <div class="col-4">
                                                        <label class="visually-hidden" for="status">Status</label>
                                                        <select id="status" name="status" class="form-control form-select" v-model="order_status_id">
                                                            <option value="">Select Order Status</option>
                                                            <option v-for="status in statuses" :value='status.id'>{{ status.status }}</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-3">
                                                        <button type="submit" class="btn btn-sm btn-primary" :disabled="order_status_id === ''" > Update </button>
                                                    </div>
                                                </form>
                                            </td>
                                        </tr>


&lt;!&ndash;                                        <tr>
                                            <th style="width: 150px">Status Update</th>
                                            <td colspan="3">
                                                <form class="row g-3 align-items-center" ref="my-form" @submit.prevent="updateItemsStatus">
                                                    <div class="col-2">
                                                        <div class="form-check">
                                                            <input id="all_select" type="checkbox" v-model="all_select" @click="allSelectCheckBox" class="form-check-input">
                                                            <label for="all_select"> {{ all_select == true ? 'Uncheck All' : "Select All" }} </label>
                                                        </div>
                                                    </div>
                                                    <div class="col-3">
                                                        <label class="visually-hidden" for="status">Status</label>
                                                        <select id="status" name="status" class="form-control form-select" v-model="status_id" :disabled="selectedItems.length === 0">
                                                            <option value="">Select Order Status</option>
                                                            <option v-for="status in statuses" :value='status.id'>{{ status.status }}</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-3">
                                                        <button type="submit" class="btn btn-sm btn-primary" :disabled="selectedItems.length === 0" > Update </button>
                                                    </div>
                                                </form>
                                            </td>
                                        </tr>&ndash;&gt;
                                        <tr>
                                            <th style="width: 150px">Delivery Boy</th>
                                            <td>
                                                <template v-if="order.delivery_boy_name">
                                                    {{ order.delivery_boy_name }}
                                                </template>
                                                <template v-else>
                                                    Not Assign
                                                </template>
                                            </td>
                                            <th style="width: 150px">Assign Delivery Boy</th>
                                            <td colspan="3">
                                                <form class="row g-3 align-items-center" ref="my-form" @submit.prevent="assignDeliveryBoy">
                                                    <div class="col-4">
                                                        <label class="visually-hidden" for="status">Delivery Boy</label>
                                                        <select id="delivery_boy_id" name="status" class="form-control form-select" v-model="delivery_boy_id">
                                                            <option value="">Select Delivery Boy</option>
                                                            <option v-for="boy in deliveryBoys" :value='boy.id'>{{ boy.name }}</option>
                                                        </select>
                                                    </div>

                                                    <div class="col-3">
                                                        <button type="submit" class="btn btn-sm btn-primary" :disabled="delivery_boy_id ==='' " > Save </button>
                                                    </div>
                                                </form>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th style="width: 150px">Items</th>
                                            <td colspan="3">
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <h4>Standard Shipping Order items</h4>
&lt;!&ndash;                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <a href="javascript:void(0)"
                                                               @click="shipprocketModalShow=true">How to manage
                                                                shiprocket order ?</a>
                                                            <button type="button" class="btn btn-sm btn-primary">
                                                                Create Shipprocket Order
                                                            </button>
                                                        </div>&ndash;&gt;
                                                    </div>
                                                </div>
                                                <div class="divider">
                                                    <div class="divider-text"><h5>List of Order Items</h5></div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-4 mb-4" v-for="item in order_items">
                                                        <ul class="list-group">


&lt;!&ndash;                                                            <li class="list-group-item  d-flex justify-content-between" v-if="item.id" >
                                                                <span><b>Order Item Id :- </b>{{ item.id }} </span>

                                                                <input type="checkbox" v-model="selectedItems" @change="selectCheckBox" :value="`${item.id}`" class="form-check-input">
                                                            </li>&ndash;&gt;

                                                            <li class="list-group-item capitalize" v-if="item.active_status" >
                                                                <b>Status :- </b>{{ item.active_status }}
                                                            </li>



&lt;!&ndash;                                                            <li class="list-group-item"><b>D.boy :- </b>{{ item.id }}</li>&ndash;&gt;

                                                            <li class="list-group-item"><b>Product Id :- </b>{{ item.product_id }}
                                                                <router-link :to="{ name: 'ViewProduct',params: { id: item.product_id }}" v-b-tooltip.hover title="View" class="btn btn-primary btn-sm"><i class="fa fa-eye"></i></router-link>
                                                            </li>

                                                            <li class="list-group-item" v-if="item.seller_name" ><b>Seller Name :- </b>{{ item.seller_name }}</li>

                                                            <li class="list-group-item"><b>User Name :- </b>{{ item.user_name }}</li>

                                                            <li class="list-group-item"><b>Variant Id :- </b>{{ item.product_variant_id }}</li>
                                                            <li class="list-group-item"><b>Name :- </b>{{ item.product_name+" ("+item.variant_name+")" }}</li>
                                                            <li class="list-group-item"><b>Quantity :- </b>{{ item.quantity }}</li>

                                                            <li class="list-group-item"><b>Price :- </b>{{ item.price }}</li>
                                                            <li class="list-group-item"><b>Discounted Price( {{ $currency }} ) :- </b>{{ item.discounted_price }}</li>
                                                            <li class="list-group-item"><b>Tax Amount( {{ $currency }} ) :- </b>{{ item.tax_amount }}</li>
                                                            <li class="list-group-item"><b>Tax Percentage(%) :- </b>{{ item.tax_percentage }}</li>
                                                            <li class="list-group-item"><b>Subtotal( {{ $currency }} ) :- </b>{{ item.sub_total }}</li>
                                                            <li class="list-group-item">
&lt;!&ndash;                                                                <a class=" col-sm-12 btn btn-success"
                                                                   href="https://api.whatsapp.com/send?phone={{ '+' + order.country_code + ' ' + order.mobile }}&text=Hello {{ order.user_name }} ,Your order with ID :
                                                                   {{ order.id }} is  {{ item.id }} . Please take a note of it. If you have further queries feel free to contact us. Thank you." target='_blank' title="Send Whatsapp Notification"><i class="fa fa-whatsapp"></i></a>&ndash;&gt;
&lt;!&ndash;                                                                <a class=" col-sm-12 btn btn-success" href="https://api.whatsapp.com/send?phone={{ '+' + order.country_code + ' ' + order.mobile }}&text={{ whatsapp_message }}" target='_blank' title="Send Whatsapp Notification">
                                                                    <i class="fa fa-whatsapp"></i>
                                                                </a>&ndash;&gt;
&lt;!&ndash;                                                                <a class=" col-sm-12 btn btn-success"
                                                                   href="https://api.whatsapp.com/send?phone=+91 07600924450&amp;text=Hello Vijya Hirani123567, Your order with ID : 437 is Received. Please take a note of it. If you have further queries feel free to contact us. Thank you."
                                                                   target="_blank" title="Send Whatsapp Notification">
                                                                    <i class="fa fa-whatsapp"></i>
                                                                </a>&ndash;&gt;
                                                                <a class=" col-sm-12 btn btn-success" :href="whatsappMessageLink(order.country_code,order.mobile,order.user_name,order.id, item.id)"
                                                                   target="_blank" title="Send Whatsapp Notification">
                                                                    <i class="fa fa-whatsapp"></i>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                    &lt;!&ndash;                                                    <div class="card col-md-4" v-for="item in order_items">
                                                                                                            <div class="card-body">

                                                                                                                <input type="checkbox" name="order_items[]" class="form-check-input"><br><br>
                                                                                                                <label class="label label-primary">Order Not Created</label><br><br>
                                                                                                                <b>Order Item Id : </b>815<br>
                                                                                                                <b>D.boy : </b>Not assigned<br>
                                                                                                                <b>Product Id : </b>562
                                                                                                                <a href="https://ecartvendor.wrteam.co.in//view-product-variants.php?id=562" class="btn btn-success btn-xs" title="View Product"><i class="fa fa-eye"></i></a><br>
                                                                                                                <b>Seller : </b>Cappuccino Store<br>
                                                                                                                <b>User Name : </b>WRTeam Customer<br>
                                                                                                                <b>Variant Id : </b>960<br>
                                                                                                                <b>Name : </b>Fresh Brew Co. French Press Singles | Mysore Nugget ( Medium Dark Roast ) | 10 servings(1pack)<br>
                                                                                                                <b>Quantity : </b>1<br>
                                                                                                                <b>Price($) : </b>350<br>
                                                                                                                <b>Discounted Price($) : </b>0<br>
                                                                                                                <b>Tax Amount($) : </b>0<br>
                                                                                                                <b>Tax Percentage(%) : </b>0<br> <b>Subtotal($) : </b>350                                              <div class="clearfix">
                                                                                                                <a class=" col-sm-12 btn btn-success" href="https://api.whatsapp.com/send?phone=+91 9876543210&amp;text=Hello WRTeam Customer, Your order with ID : 313 is Awaiting_payment. Please take a note of it. If you have further queries feel free to contact us. Thank you." target="_blank" title="Send Whatsapp Notification">
                                                                                                                    <i class="fa fa-whatsapp"></i>
                                                                                                                </a>
                                                                                              </div>
                                                                                                            </div>
                                                                                          </div>&ndash;&gt;
                                                </div>
                                            </td>
                                        </tr>


                                        <tr>
                                            <th style="width: 150px">Total ({{ $currency }})</th>
                                            <td>{{ order.total }}</td>
                                            <th style="width: 150px">D.Charge ({{ $currency }})</th>
                                            <td>{{ order.delivery_charge }}</td>
                                        </tr>


                                        <tr>
                                            <th style="width: 150px">Disc. {{ $currency }}( % )</th>
                                            <td>{{ discount_in_rupees+' ( '+ order.discount+'% )' }}</td>

                                            <th style="width: 150px">Promo Disc. ({{ $currency }})</th>
                                            <td>{{ order.promo_discount }}</td>
                                        </tr>
                                        <tr>
                                            <th style="width: 150px">Discount %</th>
                                            <td>
                                                <div class="input-group mb-3">
                                                    <input type="number" class="form-control" name="input_discount" :value="order.discount" min=0 max=100 placeholder="Discount %" aria-label="Discount %" aria-describedby="save">
                                                    <button class="btn btn-primary" type="button" id="save">Save</button>
                                                </div>
                                            </td>
                                            <th style="width: 150px">Payable Total( {{ $currency }} )</th>
                                            <td>
                                                <input type="number" class="form-control" id="final_total" name="final_total" :value="order.final_total" disabled>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th style="width: 150px">Payment Method</th>
&lt;!&ndash;                                            <td>{{ order.payment_method.toUpperCase() }}</td>&ndash;&gt;
                                            <td>{{ order.payment_method }}</td>
&lt;!&ndash;                                            <th style="width: 150px">Wallet Used</th>
                                            <td>{{ order.wallet_balance }}</td>&ndash;&gt;
                                            <th style="width: 150px">Promo Code</th>
                                            <td>{{ order.promo_code }}</td>
                                        </tr>

                                        <tr>
                                            <th style="width: 150px">Address</th>
                                            <td colspan="3">{{ order.address+', '+order.landmark+', '+order.area+', '+order.city+', '+order.state+'-'+order.pincode+', '+order.country }}</td>
                                        </tr>

                                        <tr>
                                            <th style="width: 150px">Order Date</th>
                                            <td>{{ order.created_at }}</td>
                                            <th style="width: 150px">Delivery Time</th>
                                            <td>{{ order.delivery_time }}</td>
                                        </tr>

                                        </tbody>
                                    </table>
                                </div>


                            </div>
                        </div>
                        <div class="card-footer">
                            <router-link :to="{ name: 'InvoiceOrder',params: { id: order.order_id }}" v-b-tooltip.hover title="Generate Invoice" class="btn btn-primary btn-sm pull-right"><i class="fa fa-download"></i>Generate Invoice</router-link>
                        </div>
                    </div>
                </div>-->
            </div>
            <b-modal v-model="itemModalShow" v-bind:hide-footer="true" title="Order Item Details">
                <b-container fluid>
                    <div class="row">
                        <ul class="list-group">
                            <li class="list-group-item"><b>Name :- </b>{{ item.product_name+" ("+item.variant_name+")" }}</li>
                            <li class="list-group-item capitalize" v-if="item.active_status" >
                                <b>Status :- </b>{{ item.active_status }}
                            </li>
                            <li class="list-group-item">
                                <span><b>Product Id :- </b>{{ item.product_id }}</span>
                                <router-link :to="{ name: 'ViewProduct',params: { id: item.product_id }}" v-b-tooltip.hover title="View" class="btn btn-primary btn-sm pull-right"><i class="fa fa-eye"></i></router-link>
                            </li>
                            <li class="list-group-item" v-if="item.seller_name" ><b>Seller Name :- </b>{{ item.seller_name }}</li>
                            <li class="list-group-item"><b>User Name :- </b>{{ item.user_name }}</li>
                            <li class="list-group-item"><b>Variant Id :- </b>{{ item.product_variant_id }}</li>
                            <li class="list-group-item"><b>Quantity :- </b>{{ item.quantity }}</li>
                            <li class="list-group-item"><b>Price :- </b>{{ item.price }}</li>
                            <li class="list-group-item"><b>Discounted Price( {{ $currency }} ) :- </b>{{ item.discounted_price }}</li>
                            <li class="list-group-item"><b>Tax Amount( {{ $currency }} ) :- </b>{{ item.tax_amount }}</li>
                            <li class="list-group-item"><b>Tax Percentage(%) :- </b>{{ item.tax_percentage }}</li>
                            <li class="list-group-item"><b>Subtotal( {{ $currency }} ) :- </b>{{ item.sub_total }}</li>
                            <li class="list-group-item">
                                <a class=" col-sm-12 btn btn-success" :href="whatsappMessageLink(order.country_code,order.mobile,order.user_name,order.id, item.id)"
                                   target="_blank" title="Send Whatsapp Notification">
                                    <i class="fa fa-whatsapp"></i>
                                </a>
                            </li>
                        </ul>
                    </div>
                </b-container>
            </b-modal>
        </div>
    </div>
</template>
<script>
import axios from "axios";
import Auth from '../../Auth.js';

export default {
    data: function () {
        return {
            login_user: Auth.user,

            isLoading:false,

            id: null,
            order: [],
            order_items: [],

            discount_in_rupees: 0,
            whatsapp_message:"",

            order_status_id: "",

            selectedItems: [],
            select: '',
            all_select: false,

            statuses:'',
            status_id:'',

            deliveryBoys:'',
            delivery_boy_id:'',
            itemModalShow: false,
            item:''
        }
    },
    created: function () {
        //console.log(this.$route.params);
        this.id = this.$route.params.id;
        //this.record = this.$route.params.record;
        if (this.id) {
            this.getOrderStatus();
            this.getOrder();
        }
        if (this.order.discount > 0) {
            let discounted_amount = this.order.total * this.order.discount / 100;
            let final_total = this.order.total - discounted_amount;
            this.discount_in_rupees = this.order.total - final_total;
        }
        //this.whatsapp_message = "Hello " . ucwords(this.order.user_name) . ", Your order with ID : " . this.order.id . " is " . ucwords($item[8]) . ". Please take a note of it. If you have further queries feel free to contact us. Thank you.";
    },
    methods: {
        getOrderStatus: function () {
            let vm = this;
            axios.get(this.$apiUrl + '/order_statuses').then((response) => {
                this.isLoading = false
                this.statuses = response.data.data;
                //console.log("this.statuses =>",this.statuses);
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
        },
        getOrder() {
            //console.log("this.id",this.id);
            this.isLoading = true
            axios.get(this.$apiUrl + '/orders/view/' + this.id)
                .then((response) => {
                    this.isLoading = false
                    let data = response.data;
                    if (data.status === 1) {
                        this.order = response.data.data.order;
                        this.order_items = response.data.data.order_items;
                        this.deliveryBoys = response.data.data.deliveryBoys;

                        this.delivery_boy_id = (this.order.delivery_boy_id != 0 && this.order.delivery_boy_id != "") ? this.order.delivery_boy_id:"";
                        this.order_status_id = (this.order.active_status != 0 && this.order.active_status != "") ? this.order.active_status : "";

                    } else {
                        this.showError(data.message);
                        setTimeout(() => {
                            this.$router.back();
                        }, 1000);
                    }
                }).catch(error => {
                this.isLoading = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError("Something went wrong!");
                }
            });
        },

        sendInfo(item) {
            this.item = item;
            this.itemModalShow = true;
        },

        /*deleteRecord(variant_id) {
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
                            this.getProduct();
                            this.showMessage("success", data.message);
                            //this.showSuccess(data.message);
                        });
                }
            });
        },*/

        whatsappMessageLink(country_code,mobile,user_name,order_id, item_id){
            return "https://api.whatsapp.com/send?phone=+"+country_code+" "+mobile+"&text=Hello "+user_name+" ,Your order with ID :"+order_id+" is  "+item_id+". Please take a note of it. If you have further queries feel free to contact us. Thank you.";
        },
        updateStatus(){
            let vm = this;
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
                    this.isLoading = true
                    let postData = {
                        order_id: this.id,
                        status_id:this.order_status_id
                    }
                    axios.post(this.$apiUrl + '/orders/update_status', postData).then((response) => {
                        this.isLoading = false
                        let data = response.data;
                        if (data.status === 1) {
                            //this.showSuccess(data.message);
                            this.order_status_id = '';
                            this.getOrder();
                            this.showMessage("success", data.message);
                            setTimeout(
                                function () {
                                    vm.$swal.close();
                                }, 2000);
                        } else {
                            vm.showError(data.message);
                            vm.isLoading = false;
                        }
                    }).catch(error => {
                        vm.isLoading = false;
                        this.showError("Something went wrong!");
                    });
                }
            });
        },

        assignDeliveryBoy(){
            this.isLoading = true
            let postData = {
                order_id: this.id,
                delivery_boy_id:this.delivery_boy_id
            }
            axios.post(this.$apiUrl + '/orders/assign_delivery_boy', postData).then((response) => {
                this.isLoading = false
                let data = response.data;
                if (data.status === 1) {
                    //this.showSuccess(data.message);
                    this.delivery_boy_id = '';
                    this.getOrder();
                    this.showMessage("success", data.message);
                    setTimeout(
                        function () {
                            vm.$swal.close();
                        }, 2000);
                } else {
                    vm.showError(data.message);
                    vm.isLoading = false;
                }
            }).catch(error => {
                vm.isLoading = false;
                this.showError("Something went wrong!");
            });
        },

        downloadInvoice(){
            this.isLoading = true;
            let postData = {
                order_id: this.id,
            }
            axios({
                url: this.$apiUrl + '/orders/invoice_download',
                method: 'post',
                responseType: 'blob',
                /*responseType: 'application/pdf',*/
                data: postData
            }).then((response) => {
                console.log("response =>", response.data);


                var fileURL = window.URL.createObjectURL(new Blob([response.data]));
                var fileLink = document.createElement('a');
                fileLink.href = fileURL;
                fileLink.setAttribute('download', 'Invoice-No:#'+this.id+'.pdf');
                document.body.appendChild(fileLink);
                fileLink.click();
                this.isLoading = false;
            }).catch(error => {
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError("Something went wrong!");
                }
                this.isLoading = false;
            });
        },


        allSelectCheckBox() {
            if (this.all_select == false) {
                this.all_select = true
                this.order_items.forEach(item => {
                    this.selectedItems.push(item.id)
                });
            } else {
                this.all_select = false
                this.selectedItems = []
            }
        },
        selectCheckBox() {
            let uniqueSelectedItems = [...new Set(this.selectedItems)];
            if (this.order_items.length === uniqueSelectedItems.length) {
                this.all_select = true
            } else {
                this.all_select = false
            }
        },
        updateItemsStatus(){
            let vm = this;
            let uniqueSelectedItems =  [...new Set(this.selectedItems)];
            if (uniqueSelectedItems.length !== 0) {
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
                        let ids = uniqueSelectedItems.toString();
                        this.isLoading = true
                        let postData = {
                            ids: ids,
                            status_id:this.status_id
                        }
                        axios.post(this.$apiUrl + '/orders/update_items_status', postData).then((response) => {
                            this.isLoading = false
                            let data = response.data;
                            if (data.status === 1) {
                                //this.showSuccess(data.message);
                                this.getOrder();
                                this.status_id = '';
                                this.selectedItems = [];
                                this.all_select = false;
                                this.showMessage("success", data.message);
                                setTimeout(
                                    function () {
                                        vm.$swal.close();
                                    }, 2000);
                            } else {
                                vm.showError(data.message);
                                vm.isLoading = false;
                            }
                        }).catch(error => {
                            vm.isLoading = false;
                            this.showError("Something went wrong!");
                        });
                    }
                });
            } else {
                this.showWarning("Select at least one record!");
            }
        }
    }
};
</script>
<style scoped>
    .th-width {
        width: auto;
        background: #f7f7f7;
    }
    .modal-dialog {
        border-radius: 20px;
    }
</style>
