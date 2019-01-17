function location = get_location(m,n)

[location.ii_v,location.jj_v]               = ndgrid(1.5:(m-0.5),  1.5:(n-0.5));
[location.ii_v_extra,location.jj_v_extra]   = ndgrid(0.5:(m+0.5),  0.5:(n+0.5));
[location.ii_u_extra,location.jj_u_extra]   = ndgrid( 0:m+1,        0:n+1 );
[location.ii_u1_extra,location.jj_u1_extra] = ndgrid( 0.5:(m+1.5),  0:n+1   );
[location.ii_u2_extra,location.jj_u2_extra] = ndgrid( 0:m+1,        0.5:(n+1.5)   );
location.ii_v_stream                        = location.ii_v([1:12:end end],[1:12:end end]);
location.jj_v_stream                        = location.jj_v([1:12:end end],[1:12:end end]);

return