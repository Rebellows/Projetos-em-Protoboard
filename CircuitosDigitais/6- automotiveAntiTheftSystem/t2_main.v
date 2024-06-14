module top (
    input clock, reset,
    input break, hidden_sw, ignition,
    input door_driver, door_pass, reprogram,
    input [1:0] time_param_sel, 
    input [3:0] time_value,
    output reg fuel_pump, status, siren
);

wire break_db, hidden_sw_db, ignition_db;
wire door_driver_db, door_pass_db, reprogram_db;
wire [2:0] EA;

debounce db_break (.clock(clock), .reset(reset), .noisy(break), .clean(break_db));
debounce db_hidden_sw (.clock(clock), .reset(reset), .noisy(hidden_sw), .clean(hidden_sw_db));
debounce db_ignition (.clock(clock), .reset(reset), .noisy(ignition), .clean(ignition_db));
debounce db_door_driver (.clock(clock), .reset(reset), .noisy(door_driver), .clean(door_driver_db));
debounce db_door_pass (.clock(clock), .reset(reset), .noisy(door_pass), .clean(door_pass_db));
debounce db_reprogram (.clock(clock), .reset(reset), .noisy(reprogram), .clean(reprogram_db));

wire enable_siren, start_timer, one_hz_enable, two_hz_enable, expired;
wire [1:0] interval;
wire [3:0] value, timer_count;

time_parameters tp (
    .clock(clock),
    .reset(reset),
    .interval(interval),
    .time_param_sel(time_param_sel),
    .reprogram(reprogram_db),
    .time_value(time_value),
    .value(value)
);

timer t (
    .clock(clock),
    .reset(reset),
    .value(value),
    .start_timer(start_timer),
    .one_hz_enable(one_hz_enable),
    .two_hz_enable(two_hz_enable),
    .expired(expired),
    .timer_count(timer_count)
);

fsm fsm (
    .clock(clock),
    .reset(reset),
    .ignition(ignition_db),
    .door_driver(door_driver_db),
    .door_pass(door_pass_db),
    .reprogram(reprogram_db),
    .expired(expired),
    .one_hz_enable(one_hz_enable),
    .status(status),
    .enable_siren(enable_siren),
    .start_timer(start_timer),
    .interval(interval),
    .EA(EA)
);

fuel_pump_logic fpl (
    .clock(clock),
    .reset(reset),
    .break(break_db),
    .ignition(ignition_db),
    .hidden_sw(hidden_sw_db),
    .fuel_pump(fuel_pump)
);

siren_generator sg (
    .clock(clock),
    .reset(reset),
    .two_hz_enable(two_hz_enable),
    .enable_siren(enable_siren),
    .siren(siren)
);

dspl_drv_NexysA7 dspl (
    .reset(reset),
    .clock(clock),
    .EA(d1),
    .timer_count(d2),
    d3,
    d4,
    d5,
    d6,
    d7,
    d8,
    dec_cat,
    an
);

endmodule
