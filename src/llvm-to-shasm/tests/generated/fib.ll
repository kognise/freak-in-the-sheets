; ModuleID = '/Users/thomasbreydo/dev/freak-in-the-sheets/src/llvm-to-shasm/tests/fixtures/fib.c'
source_filename = "/Users/thomasbreydo/dev/freak-in-the-sheets/src/llvm-to-shasm/tests/fixtures/fib.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca [18 x i64], align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  store i64 17, ptr %2, align 8
  %6 = getelementptr inbounds [18 x i64], ptr %3, i64 0, i64 0
  store i64 0, ptr %6, align 8
  %7 = getelementptr inbounds [18 x i64], ptr %3, i64 0, i64 1
  store i64 1, ptr %7, align 8
  store i64 2, ptr %4, align 8
  br label %8

8:                                                ; preds = %24, %0
  %9 = load i64, ptr %4, align 8
  %10 = load i64, ptr %2, align 8
  %11 = icmp sle i64 %9, %10
  br i1 %11, label %12, label %27

12:                                               ; preds = %8
  %13 = load i64, ptr %4, align 8
  %14 = sub nsw i64 %13, 1
  %15 = getelementptr inbounds [18 x i64], ptr %3, i64 0, i64 %14
  %16 = load i64, ptr %15, align 8
  %17 = load i64, ptr %4, align 8
  %18 = sub nsw i64 %17, 2
  %19 = getelementptr inbounds [18 x i64], ptr %3, i64 0, i64 %18
  %20 = load i64, ptr %19, align 8
  %21 = add nsw i64 %16, %20
  %22 = load i64, ptr %4, align 8
  %23 = getelementptr inbounds [18 x i64], ptr %3, i64 0, i64 %22
  store i64 %21, ptr %23, align 8
  br label %24

24:                                               ; preds = %12
  %25 = load i64, ptr %4, align 8
  %26 = add nsw i64 %25, 1
  store i64 %26, ptr %4, align 8
  br label %8, !llvm.loop !6

27:                                               ; preds = %8
  %28 = load i64, ptr %2, align 8
  %29 = getelementptr inbounds [18 x i64], ptr %3, i64 0, i64 %28
  %30 = load i64, ptr %29, align 8
  store i64 %30, ptr %5, align 8
  %31 = load i64, ptr %5, align 8
  %32 = trunc i64 %31 to i32
  ret i32 %32
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 4]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Apple clang version 15.0.0 (clang-1500.3.9.4)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
