module hexdecoder (c,h);
        input[3:0] c;
        output[6:0] h;
        wire h0,h1,h2,h3,h4,h5,h6;
        wire c3,c2,c1,c0;

        assign c0 = c[0];
        assign c1 = c[1];
        assign c2 = c[2];
        assign c3 = c[3];
        assign h0 = !(~c2&~c0 | ~c3&c1 | c2&c1 | c3&~c0 | ~c3&c2&c0 | c3&~c2&~c1);
        assign h1 = !(~c2&~c0 | ~c2&~c1 | ~c3&~c1&~c0 | c3&~c1&c0 | ~c3&c1&c0);
        assign h2 = !(c3&~c2 | ~c1&c0 | ~c2&~c1 | ~c3&c0 | ~c3&c2 );
        assign h3 = !(~c3&~c2&~c0 | ~c2&c1&c0 | c2&~c1&c0 | c3&~c1 | c2&c1&~c0);
        assign h4 = !(~c2&~c0 | c3&c2 | c1&~c0 | c3&c1);
        assign h5 = !(~c1&~c0 | c3&~c2 | c2&~c0 | c3&c1 | ~c3&c2);
        assign h6 = !(c3&~c2 | c1&~c0 | c3&c0 | ~c3&c2&~c1 | ~c2&c1);

        assign h = {h6,h5,h4,h3,h2,h1,h0};

endmodule