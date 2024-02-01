<?php

use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    Log::info('This is a success test log message for three channels (single,slack,loki) with our team.');
    Log::error('This is an error test log message for three channels (single,slack,loki) with our team.');
    return view('welcome');
});
