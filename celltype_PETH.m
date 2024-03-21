clear all

U150 = readtable('D:\NHP project\분석 관련\1.Singificace test (2)\Significance test results_total_summary_150ms.xlsx');
U300 = readtable('D:\NHP project\분석 관련\1.Singificace test (2)\Significance test results_total_summary_300ms.xlsx');

 U150.Properties.VariableNames(8) = "go";
U150.Properties.VariableNames(7) = "obj";
U150.Properties.VariableNames(6) = "start";
U150.Properties.VariableNames(9) = "end";

 U300.Properties.VariableNames(8) = "go";
U300.Properties.VariableNames(7) = "obj";
U300.Properties.VariableNames(6) = "start";
U300.Properties.VariableNames(9) = "end";



%%
dat150= [sum(U150.start & U150.x1Events) sum(U150.start & U150.obj) sum(U150.start & U150.go) sum(U150.start & U150.end);...
    sum(U150.obj & U150.x1Events) sum(U150.start & U150.obj) sum(U150.obj & U150.go) sum(U150.obj & U150.end);...
    sum(U150.go & U150.x1Events) sum(U150.start & U150.go) sum(U150.obj & U150.go) sum(U150.go & U150.end);...
    sum(U150.end & U150.x1Events) sum(U150.end & U150.start) sum(U150.end & U150.obj) sum(U150.end & U150.go)];

dat300= [sum(U300.start & U300.x1Events) sum(U300.start & U300.obj) sum(U300.start & U300.go) sum(U300.start & U300.end);...
    sum(U300.obj & U300.x1Events) sum(U300.start & U300.obj) sum(U300.obj & U300.go) sum(U300.obj & U300.end);...
    sum(U300.go & U300.x1Events) sum(U300.start & U300.go) sum(U300.obj & U300.go) sum(U300.go & U300.end);...
    sum(U300.end & U300.x1Events) sum(U300.end & U300.start) sum(U300.end & U300.obj) sum(U300.end & U300.go)];

%%
figure
subplot(1,2,1)
bar(dat300,'stacked'); title('cell type - 300ms interval'); ylim([0 250])

subplot(1,2,2)
bar(dat150,'stacked'); title('cell type - 150ms interval'); ylim([0 250])


%%
dat150= [sum(U150.start & U150.x1Events) sum(U150.start & U150.x2Events) sum(U150.start & U150.x3Events) sum(U150.start & U150.x4Events);...
    sum(U150.obj & U150.x1Events) sum(U150.x2Events & U150.obj) sum(U150.obj & U150.x3Events) sum(U150.obj & U150.x4Events);...
    sum(U1v50.go & U150.x1Events) sum(U150.x2Events & U150.go) sum(U150.x3Events & U150.go) sum(U150.go & U150.x4Events);...
    sum(U150.end & U150.x1Events) sum(U150.end & U150.x2Events) sum(U150.end & U150.x3Events) sum(U150.end & U150.x4Events)];

dat300= [sum(U300.start & U300.x1Events) sum(U300.start & U300.x2Events) sum(U300.start & U300.x3Events) sum(U300.start & U300.x4Events);...
    sum(U300.obj & U300.x1Events) sum(U300.x2Events & U300.obj) sum(U300.obj & U300.x3Events) sum(U300.obj & U300.x4Events);...
    sum(U300.go & U300.x1Events) sum(U300.x2Events & U300.go) sum(U300.x3Events & U300.go) sum(U300.go & U300.x4Events);...
    sum(U300.end & U300.x1Events) sum(U300.end & U300.x2Events) sum(U300.end & U300.x3Events) sum(U300.end & U300.x4Events)];

%%
figure
subplot(1,2,1)
bar(dat300,'stacked'); title('cell type - 300ms interval'); ylim([0 250])

subplot(1,2,2)
bar(dat150,'stacked'); title('cell type - 150ms interval'); ylim([0 250])
