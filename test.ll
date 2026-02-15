; ModuleID = 'test.f6903de1f4dc8678-cgu.0'
source_filename = "test.f6903de1f4dc8678-cgu.0"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i686-unknown-linux-gnu"

@alloc_92db484cf7a913a804cc61f4ce4495ec = private unnamed_addr constant [115 x i8] c"/Users/kognise/.rustup/toolchains/nightly-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/range.rs\00", align 1
@alloc_66274825eb636fa7f7696adf85f8a46f = private unnamed_addr constant <{ ptr, [12 x i8] }> <{ ptr @alloc_92db484cf7a913a804cc61f4ce4495ec, [12 x i8] c"r\00\00\00\B1\01\00\00\01\00\00\00" }>, align 4
@alloc_3e1ebac14318b612ab4efabc52799932 = private unnamed_addr constant [186 x i8] c"unsafe precondition(s) violated: usize::unchecked_add cannot overflow\0A\0AThis indicates a bug in the program. This Undefined Behavior check is optional, and cannot be relied on for safety.", align 1
@anon.336b585d289a3436e5d40f2fd329ed10.0 = private unnamed_addr constant <{ [4 x i8], [4 x i8] }> <{ [4 x i8] zeroinitializer, [4 x i8] undef }>, align 4
@_ZN4test1N17hac9a5cb9c6f0070cE = internal constant [4 x i8] c"\0A\00\00\00", align 4
@_ZN4test3OUT17h5e7106a9e4657b56E = internal global [200 x i8] zeroinitializer, align 4
@alloc_2c79a96465fc8bede061ce727a47d58b = private unnamed_addr constant [8 x i8] c"test.rs\00", align 1
@alloc_6a4d875128ae3ef65aa076bbe745b628 = private unnamed_addr constant <{ ptr, [12 x i8] }> <{ ptr @alloc_2c79a96465fc8bede061ce727a47d58b, [12 x i8] c"\07\00\00\00\09\00\00\00\05\00\00\00" }>, align 4
@alloc_8581ea498050a98ca95e07b78c777472 = private unnamed_addr constant <{ ptr, [12 x i8] }> <{ ptr @alloc_2c79a96465fc8bede061ce727a47d58b, [12 x i8] c"\07\00\00\00\0A\00\00\00\05\00\00\00" }>, align 4
@alloc_fbcf980fa2dc4a26ccf45013e9427dea = private unnamed_addr constant <{ ptr, [12 x i8] }> <{ ptr @alloc_2c79a96465fc8bede061ce727a47d58b, [12 x i8] c"\07\00\00\00\0E\00\00\00\05\00\00\00" }>, align 4
@alloc_db9747151117d6aa304c10052396b038 = private unnamed_addr constant <{ ptr, [12 x i8] }> <{ ptr @alloc_2c79a96465fc8bede061ce727a47d58b, [12 x i8] c"\07\00\00\00\0C\00\00\00\16\00\00\00" }>, align 4
@alloc_75cea8b7b17b34ca530d3d1bd208925b = private unnamed_addr constant <{ ptr, [12 x i8] }> <{ ptr @alloc_2c79a96465fc8bede061ce727a47d58b, [12 x i8] c"\07\00\00\00\0C\00\00\00\12\00\00\00" }>, align 4
@alloc_84aa0a5f2e7a21df563b5bfe15d31e38 = private unnamed_addr constant <{ ptr, [12 x i8] }> <{ ptr @alloc_2c79a96465fc8bede061ce727a47d58b, [12 x i8] c"\07\00\00\00\0C\00\00\00#\00\00\00" }>, align 4
@alloc_16774d30b990b3c657f1113a3cde29f3 = private unnamed_addr constant <{ ptr, [12 x i8] }> <{ ptr @alloc_2c79a96465fc8bede061ce727a47d58b, [12 x i8] c"\07\00\00\00\0C\00\00\00\1F\00\00\00" }>, align 4
@alloc_d30162c950d6fbfc115c39ac719d8316 = private unnamed_addr constant <{ ptr, [12 x i8] }> <{ ptr @alloc_2c79a96465fc8bede061ce727a47d58b, [12 x i8] c"\07\00\00\00\0C\00\00\00\09\00\00\00" }>, align 4

; __rustc::rust_begin_unwind
; Function Attrs: noreturn nounwind
define hidden void @_RNvCseSwM98JZ0fV_7___rustc17rust_begin_unwind(ptr align 4 %_1) unnamed_addr #0 {
start:
  br label %bb1

bb1:                                              ; preds = %bb1, %start
  br label %bb1
}

; <core::ops::range::RangeInclusive<T> as core::iter::range::RangeInclusiveIteratorImpl>::spec_next
; Function Attrs: inlinehint nounwind
define internal { i32, i32 } @"_ZN107_$LT$core..ops..range..RangeInclusive$LT$T$GT$$u20$as$u20$core..iter..range..RangeInclusiveIteratorImpl$GT$9spec_next17h3195764a3d401149E"(ptr align 4 %self) unnamed_addr #1 {
start:
  %_6 = alloca [4 x i8], align 4
  %_0 = alloca [8 x i8], align 4
  %0 = getelementptr inbounds i8, ptr %self, i32 8
  %1 = load i8, ptr %0, align 4
  %_10 = trunc nuw i8 %1 to i1
  br i1 %_10, label %bb9, label %bb10

bb10:                                             ; preds = %start
  %_13 = getelementptr inbounds i8, ptr %self, i32 4
  %_3.i = load i32, ptr %self, align 4
  %_4.i = load i32, ptr %_13, align 4
  %_0.i = icmp ule i32 %_3.i, %_4.i
  %_2 = xor i1 %_0.i, true
  br i1 %_2, label %bb1, label %bb2

bb9:                                              ; preds = %start
  br label %bb1

bb2:                                              ; preds = %bb10
  %_5 = getelementptr inbounds i8, ptr %self, i32 4
  %_3.i1 = load i32, ptr %self, align 4
  %_4.i2 = load i32, ptr %_5, align 4
  %_0.i3 = icmp ult i32 %_3.i1, %_4.i2
  br i1 %_0.i3, label %bb4, label %bb6

bb1:                                              ; preds = %bb9, %bb10
  store i32 0, ptr %_0, align 4
  br label %bb8

bb6:                                              ; preds = %bb2
  %2 = getelementptr inbounds i8, ptr %self, i32 8
  store i8 1, ptr %2, align 4
  %3 = load i32, ptr %self, align 4
  store i32 %3, ptr %_6, align 4
  br label %bb7

bb4:                                              ; preds = %bb2
  %_8 = load i32, ptr %self, align 4
; call <usize as core::iter::range::Step>::forward_unchecked
  %n = call i32 @"_ZN49_$LT$usize$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17ha82cd840f57539deE"(i32 %_8, i32 1) #7
  %4 = load i32, ptr %self, align 4
  store i32 %4, ptr %_6, align 4
  store i32 %n, ptr %self, align 4
  br label %bb7

bb7:                                              ; preds = %bb4, %bb6
  %5 = load i32, ptr %_6, align 4
  %6 = getelementptr inbounds i8, ptr %_0, i32 4
  store i32 %5, ptr %6, align 4
  store i32 1, ptr %_0, align 4
  br label %bb8

bb8:                                              ; preds = %bb1, %bb7
  %7 = load i32, ptr %_0, align 4
  %8 = getelementptr inbounds i8, ptr %_0, i32 4
  %9 = load i32, ptr %8, align 4
  %10 = insertvalue { i32, i32 } poison, i32 %7, 0
  %11 = insertvalue { i32, i32 } %10, i32 %9, 1
  ret { i32, i32 } %11
}

; <usize as core::iter::range::Step>::forward_unchecked
; Function Attrs: inlinehint nounwind
define internal i32 @"_ZN49_$LT$usize$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17ha82cd840f57539deE"(i32 %start1, i32 %n) unnamed_addr #1 {
start:
  br label %bb1

bb1:                                              ; preds = %start
; call core::num::<impl usize>::unchecked_add::precondition_check
  call void @"_ZN4core3num23_$LT$impl$u20$usize$GT$13unchecked_add18precondition_check17h4eee38925179dd8cE"(i32 %start1, i32 %n, ptr align 4 @alloc_66274825eb636fa7f7696adf85f8a46f) #7
  br label %bb2

bb2:                                              ; preds = %bb1
  %_0 = add nuw i32 %start1, %n
  ret i32 %_0
}

; core::num::<impl usize>::unchecked_add::precondition_check
; Function Attrs: inlinehint nounwind
define internal void @"_ZN4core3num23_$LT$impl$u20$usize$GT$13unchecked_add18precondition_check17h4eee38925179dd8cE"(i32 %lhs, i32 %rhs, ptr align 4 %0) unnamed_addr #1 {
start:
  %_6 = alloca [8 x i8], align 4
  %_4 = alloca [24 x i8], align 4
  %_8.0 = add i32 %lhs, %rhs
  %_8.1 = icmp ult i32 %_8.0, %lhs
  br i1 %_8.1, label %bb1, label %bb2

bb2:                                              ; preds = %start
  ret void

bb1:                                              ; preds = %start
  %1 = getelementptr inbounds nuw { ptr, i32 }, ptr %_6, i32 0
  store ptr @alloc_3e1ebac14318b612ab4efabc52799932, ptr %1, align 4
  %2 = getelementptr inbounds i8, ptr %1, i32 4
  store i32 186, ptr %2, align 4
  store ptr %_6, ptr %_4, align 4
  %3 = getelementptr inbounds i8, ptr %_4, i32 4
  store i32 1, ptr %3, align 4
  %4 = load ptr, ptr @anon.336b585d289a3436e5d40f2fd329ed10.0, align 4
  %5 = load i32, ptr getelementptr inbounds (i8, ptr @anon.336b585d289a3436e5d40f2fd329ed10.0, i32 4), align 4
  %6 = getelementptr inbounds i8, ptr %_4, i32 16
  store ptr %4, ptr %6, align 4
  %7 = getelementptr inbounds i8, ptr %6, i32 4
  store i32 %5, ptr %7, align 4
  %8 = getelementptr inbounds i8, ptr %_4, i32 8
  store ptr inttoptr (i32 4 to ptr), ptr %8, align 4
  %9 = getelementptr inbounds i8, ptr %8, i32 4
  store i32 0, ptr %9, align 4
; call core::panicking::panic_nounwind_fmt
  call void @_ZN4core9panicking18panic_nounwind_fmt17he6e0d19f0c607fb9E(ptr align 4 %_4, i1 zeroext false, ptr align 4 %0) #8
  unreachable
}

; core::ops::range::RangeInclusive<Idx>::new
; Function Attrs: inlinehint nounwind
define internal void @"_ZN4core3ops5range25RangeInclusive$LT$Idx$GT$3new17h2bf67fe89141f8e2E"(ptr sret([12 x i8]) align 4 %_0, i32 %start1, i32 %end) unnamed_addr #1 {
start:
  store i32 %start1, ptr %_0, align 4
  %0 = getelementptr inbounds i8, ptr %_0, i32 4
  store i32 %end, ptr %0, align 4
  %1 = getelementptr inbounds i8, ptr %_0, i32 8
  store i8 0, ptr %1, align 4
  ret void
}

; core::iter::range::<impl core::iter::traits::iterator::Iterator for core::ops::range::RangeInclusive<A>>::next
; Function Attrs: inlinehint nounwind
define internal { i32, i32 } @"_ZN4core4iter5range110_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..RangeInclusive$LT$A$GT$$GT$4next17h05afa540ba2115f9E"(ptr align 4 %self) unnamed_addr #1 {
start:
; call <core::ops::range::RangeInclusive<T> as core::iter::range::RangeInclusiveIteratorImpl>::spec_next
  %0 = call { i32, i32 } @"_ZN107_$LT$core..ops..range..RangeInclusive$LT$T$GT$$u20$as$u20$core..iter..range..RangeInclusiveIteratorImpl$GT$9spec_next17h3195764a3d401149E"(ptr align 4 %self) #7
  %_0.0 = extractvalue { i32, i32 } %0, 0
  %_0.1 = extractvalue { i32, i32 } %0, 1
  %1 = insertvalue { i32, i32 } poison, i32 %_0.0, 0
  %2 = insertvalue { i32, i32 } %1, i32 %_0.1, 1
  ret { i32, i32 } %2
}

; <I as core::iter::traits::collect::IntoIterator>::into_iter
; Function Attrs: inlinehint nounwind
define internal void @"_ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h3a9fb79fe2ce3ed4E"(ptr sret([12 x i8]) align 4 %_0, ptr align 4 %self) unnamed_addr #1 {
start:
  call void @llvm.memcpy.p0.p0.i32(ptr align 4 %_0, ptr align 4 %self, i32 12, i1 false)
  ret void
}

; Function Attrs: nounwind
define dso_local i32 @_start() unnamed_addr #2 {
start:
  %_12 = alloca [8 x i8], align 4
  %iter = alloca [12 x i8], align 4
  %_8 = alloca [12 x i8], align 4
  %_7 = alloca [12 x i8], align 4
  %_73 = icmp eq i32 ptrtoint (ptr @_ZN4test3OUT17h5e7106a9e4657b56E to i32), 0
  %_74 = and i1 %_73, true
  %_75 = xor i1 %_74, true
  br i1 %_75, label %bb23, label %panic

bb23:                                             ; preds = %start
  store i32 0, ptr @_ZN4test3OUT17h5e7106a9e4657b56E, align 4
  %_80 = icmp eq i32 ptrtoint (ptr @_ZN4test3OUT17h5e7106a9e4657b56E to i32), 0
  %_81 = and i1 %_80, true
  %_82 = xor i1 %_81, true
  br i1 %_82, label %bb24, label %panic1

panic:                                            ; preds = %start
; call core::panicking::panic_null_pointer_dereference
  call void @_ZN4core9panicking30panic_null_pointer_dereference17h18bc1a70ce8477bfE(ptr align 4 @alloc_6a4d875128ae3ef65aa076bbe745b628) #8
  unreachable

bb24:                                             ; preds = %bb23
  store i32 1, ptr getelementptr inbounds nuw (i32, ptr @_ZN4test3OUT17h5e7106a9e4657b56E, i32 1), align 4
  %_9 = load i32, ptr @_ZN4test1N17hac9a5cb9c6f0070cE, align 4
; call core::ops::range::RangeInclusive<Idx>::new
  call void @"_ZN4core3ops5range25RangeInclusive$LT$Idx$GT$3new17h2bf67fe89141f8e2E"(ptr sret([12 x i8]) align 4 %_8, i32 2, i32 %_9) #7
; call <I as core::iter::traits::collect::IntoIterator>::into_iter
  call void @"_ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h3a9fb79fe2ce3ed4E"(ptr sret([12 x i8]) align 4 %_7, ptr align 4 %_8) #7
  call void @llvm.memcpy.p0.p0.i32(ptr align 4 %iter, ptr align 4 %_7, i32 12, i1 false)
  br label %bb5

panic1:                                           ; preds = %bb23
; call core::panicking::panic_null_pointer_dereference
  call void @_ZN4core9panicking30panic_null_pointer_dereference17h18bc1a70ce8477bfE(ptr align 4 @alloc_8581ea498050a98ca95e07b78c777472) #8
  unreachable

bb5:                                              ; preds = %bb27, %bb24
; call core::iter::range::<impl core::iter::traits::iterator::Iterator for core::ops::range::RangeInclusive<A>>::next
  %0 = call { i32, i32 } @"_ZN4core4iter5range110_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..RangeInclusive$LT$A$GT$$GT$4next17h05afa540ba2115f9E"(ptr align 4 %iter) #7
  %1 = extractvalue { i32, i32 } %0, 0
  %2 = extractvalue { i32, i32 } %0, 1
  store i32 %1, ptr %_12, align 4
  %3 = getelementptr inbounds i8, ptr %_12, i32 4
  store i32 %2, ptr %3, align 4
  %_14 = load i32, ptr %_12, align 4
  %4 = getelementptr inbounds i8, ptr %_12, i32 4
  %5 = load i32, ptr %4, align 4
  %6 = trunc nuw i32 %_14 to i1
  br i1 %6, label %bb8, label %bb9

bb8:                                              ; preds = %bb5
  %7 = getelementptr inbounds i8, ptr %_12, i32 4
  %i = load i32, ptr %7, align 4
  %_19.0 = sub i32 %i, 1
  %_19.1 = icmp ult i32 %i, 1
  br i1 %_19.1, label %panic4, label %bb10

bb9:                                              ; preds = %bb5
  %_30 = load i32, ptr @_ZN4test1N17hac9a5cb9c6f0070cE, align 4
  %_32 = icmp ult i32 %_30, 50
  br i1 %_32, label %bb16, label %panic2

bb16:                                             ; preds = %bb9
  %_108 = icmp eq i32 ptrtoint (ptr @_ZN4test3OUT17h5e7106a9e4657b56E to i32), 0
  %_109 = and i1 %_108, true
  %_110 = xor i1 %_109, true
  br i1 %_110, label %bb28, label %panic3

panic2:                                           ; preds = %bb9
; call core::panicking::panic_bounds_check
  call void @_ZN4core9panicking18panic_bounds_check17ha7ac4bbda4f787efE(i32 %_30, i32 50, ptr align 4 @alloc_fbcf980fa2dc4a26ccf45013e9427dea) #8
  unreachable

bb28:                                             ; preds = %bb16
  %8 = getelementptr inbounds nuw i32, ptr @_ZN4test3OUT17h5e7106a9e4657b56E, i32 %_30
  %_0 = load i32, ptr %8, align 4
  ret i32 %_0

panic3:                                           ; preds = %bb16
; call core::panicking::panic_null_pointer_dereference
  call void @_ZN4core9panicking30panic_null_pointer_dereference17h18bc1a70ce8477bfE(ptr align 4 @alloc_fbcf980fa2dc4a26ccf45013e9427dea) #8
  unreachable

bb10:                                             ; preds = %bb8
  %_20 = icmp ult i32 %_19.0, 50
  br i1 %_20, label %bb11, label %panic5

panic4:                                           ; preds = %bb8
; call core::panicking::panic_const::panic_const_sub_overflow
  call void @_ZN4core9panicking11panic_const24panic_const_sub_overflow17h964993a4be4b155eE(ptr align 4 @alloc_db9747151117d6aa304c10052396b038) #8
  unreachable

bb11:                                             ; preds = %bb10
  %_87 = icmp eq i32 ptrtoint (ptr @_ZN4test3OUT17h5e7106a9e4657b56E to i32), 0
  %_88 = and i1 %_87, true
  %_89 = xor i1 %_88, true
  br i1 %_89, label %bb25, label %panic6

panic5:                                           ; preds = %bb10
; call core::panicking::panic_bounds_check
  call void @_ZN4core9panicking18panic_bounds_check17ha7ac4bbda4f787efE(i32 %_19.0, i32 50, ptr align 4 @alloc_75cea8b7b17b34ca530d3d1bd208925b) #8
  unreachable

bb25:                                             ; preds = %bb11
  %9 = getelementptr inbounds nuw i32, ptr @_ZN4test3OUT17h5e7106a9e4657b56E, i32 %_19.0
  %_16 = load i32, ptr %9, align 4
  %_24.0 = sub i32 %i, 2
  %_24.1 = icmp ult i32 %i, 2
  br i1 %_24.1, label %panic7, label %bb12

panic6:                                           ; preds = %bb11
; call core::panicking::panic_null_pointer_dereference
  call void @_ZN4core9panicking30panic_null_pointer_dereference17h18bc1a70ce8477bfE(ptr align 4 @alloc_75cea8b7b17b34ca530d3d1bd208925b) #8
  unreachable

bb12:                                             ; preds = %bb25
  %_25 = icmp ult i32 %_24.0, 50
  br i1 %_25, label %bb13, label %panic8

panic7:                                           ; preds = %bb25
; call core::panicking::panic_const::panic_const_sub_overflow
  call void @_ZN4core9panicking11panic_const24panic_const_sub_overflow17h964993a4be4b155eE(ptr align 4 @alloc_84aa0a5f2e7a21df563b5bfe15d31e38) #8
  unreachable

bb13:                                             ; preds = %bb12
  %_94 = icmp eq i32 ptrtoint (ptr @_ZN4test3OUT17h5e7106a9e4657b56E to i32), 0
  %_95 = and i1 %_94, true
  %_96 = xor i1 %_95, true
  br i1 %_96, label %bb26, label %panic9

panic8:                                           ; preds = %bb12
; call core::panicking::panic_bounds_check
  call void @_ZN4core9panicking18panic_bounds_check17ha7ac4bbda4f787efE(i32 %_24.0, i32 50, ptr align 4 @alloc_16774d30b990b3c657f1113a3cde29f3) #8
  unreachable

bb26:                                             ; preds = %bb13
  %10 = getelementptr inbounds nuw i32, ptr @_ZN4test3OUT17h5e7106a9e4657b56E, i32 %_24.0
  %_21 = load i32, ptr %10, align 4
  %11 = call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 %_16, i32 %_21)
  %_26.0 = extractvalue { i32, i1 } %11, 0
  %_26.1 = extractvalue { i32, i1 } %11, 1
  br i1 %_26.1, label %panic10, label %bb14

panic9:                                           ; preds = %bb13
; call core::panicking::panic_null_pointer_dereference
  call void @_ZN4core9panicking30panic_null_pointer_dereference17h18bc1a70ce8477bfE(ptr align 4 @alloc_16774d30b990b3c657f1113a3cde29f3) #8
  unreachable

bb14:                                             ; preds = %bb26
  %_28 = icmp ult i32 %i, 50
  br i1 %_28, label %bb15, label %panic11

panic10:                                          ; preds = %bb26
; call core::panicking::panic_const::panic_const_add_overflow
  call void @_ZN4core9panicking11panic_const24panic_const_add_overflow17h2111d444a755f3b9E(ptr align 4 @alloc_75cea8b7b17b34ca530d3d1bd208925b) #8
  unreachable

bb15:                                             ; preds = %bb14
  %_101 = icmp eq i32 ptrtoint (ptr @_ZN4test3OUT17h5e7106a9e4657b56E to i32), 0
  %_102 = and i1 %_101, true
  %_103 = xor i1 %_102, true
  br i1 %_103, label %bb27, label %panic12

panic11:                                          ; preds = %bb14
; call core::panicking::panic_bounds_check
  call void @_ZN4core9panicking18panic_bounds_check17ha7ac4bbda4f787efE(i32 %i, i32 50, ptr align 4 @alloc_d30162c950d6fbfc115c39ac719d8316) #8
  unreachable

bb27:                                             ; preds = %bb15
  %12 = getelementptr inbounds nuw i32, ptr @_ZN4test3OUT17h5e7106a9e4657b56E, i32 %i
  store i32 %_26.0, ptr %12, align 4
  br label %bb5

panic12:                                          ; preds = %bb15
; call core::panicking::panic_null_pointer_dereference
  call void @_ZN4core9panicking30panic_null_pointer_dereference17h18bc1a70ce8477bfE(ptr align 4 @alloc_d30162c950d6fbfc115c39ac719d8316) #8
  unreachable

bb7:                                              ; No predecessors!
  unreachable
}

; core::panicking::panic_nounwind_fmt
; Function Attrs: cold noinline noreturn nounwind
declare void @_ZN4core9panicking18panic_nounwind_fmt17he6e0d19f0c607fb9E(ptr align 4, i1 zeroext, ptr align 4) unnamed_addr #3

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #4

; core::panicking::panic_null_pointer_dereference
; Function Attrs: cold minsize noinline noreturn nounwind optsize
declare void @_ZN4core9panicking30panic_null_pointer_dereference17h18bc1a70ce8477bfE(ptr align 4) unnamed_addr #5

; core::panicking::panic_bounds_check
; Function Attrs: cold minsize noinline noreturn nounwind optsize
declare void @_ZN4core9panicking18panic_bounds_check17ha7ac4bbda4f787efE(i32, i32, ptr align 4) unnamed_addr #5

; core::panicking::panic_const::panic_const_sub_overflow
; Function Attrs: cold noinline noreturn nounwind
declare void @_ZN4core9panicking11panic_const24panic_const_sub_overflow17h964993a4be4b155eE(ptr align 4) unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i32, i1 } @llvm.sadd.with.overflow.i32(i32, i32) #6

; core::panicking::panic_const::panic_const_add_overflow
; Function Attrs: cold noinline noreturn nounwind
declare void @_ZN4core9panicking11panic_const24panic_const_add_overflow17h2111d444a755f3b9E(ptr align 4) unnamed_addr #3

attributes #0 = { noreturn nounwind "probe-stack"="inline-asm" "target-cpu"="pentium4" }
attributes #1 = { inlinehint nounwind "probe-stack"="inline-asm" "target-cpu"="pentium4" }
attributes #2 = { nounwind "probe-stack"="inline-asm" "target-cpu"="pentium4" }
attributes #3 = { cold noinline noreturn nounwind "probe-stack"="inline-asm" "target-cpu"="pentium4" }
attributes #4 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { cold minsize noinline noreturn nounwind optsize "probe-stack"="inline-asm" "target-cpu"="pentium4" }
attributes #6 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { nounwind }
attributes #8 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{!"rustc version 1.92.0-nightly (0be8e1608 2025-09-19)"}
