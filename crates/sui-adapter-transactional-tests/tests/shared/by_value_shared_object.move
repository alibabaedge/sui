// Copyright (c) 2022, Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

// tests that shared objects can

//# init --addresses t1=0x0 t2=0x0

//# publish

module t2::o2 {
    use sui::id::{Self, VersionedID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct O2 has key, store {
        id: VersionedID,
    }

    public entry fun create(ctx: &mut TxContext) {
        let o = O2 { id: tx_context::new_id(ctx) };
        transfer::share_object(o)
    }

    public entry fun consume_o2(o2: O2) {
        let O2 { id } = o2;
        id::delete(id);
    }
}

//# publish

module t1::o1 {
    use t2::o2::{Self, O2};

    public entry fun consume_o2(o2: O2) {
        o2::consume_o2(o2);
    }
}


//# run t2::o2::create

//# view-object 107

//# run t1::o1::consume_o2 --args object(107)

//# run t2::o2::consume_o2 --args object(107)
