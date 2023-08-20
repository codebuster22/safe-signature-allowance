/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceTokenAllowlist is SignatureAllowanceSetup {
    function testUserCannotRemoveTokenNotAllowlisted() public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));
        console2.log(
            "SignatureAllowance: User trying to remove token that isn't added to allowlist"
        );
        // create new token
        MockToken tokenToBeRemoved = new MockToken();
        // expect revert when trying to remove the token from allowlist
        vm.expectRevert(SignatureAllowance.TokenNotInAllowlist.selector);
        signatureAllowance.removeTokenFromAllowlist(address(tokenToBeRemoved));

        // ensure token is not added to allowlist
        assertFalse(
            signatureAllowance.checkTokenAllowlisted(address(tokenToBeRemoved))
        );
        console2.log(
            "SignatureAllowance [Passed]: User cannot remove token that is not in allowlist"
        );
    }

    function testUserTryingToAddTokenNotAllowlisted() public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));
        console2.log(
            "SignatureAllowance: User trying to add token that isn't added to allowlist"
        );
        // create new token
        MockToken tokenToBeAdded = new MockToken();
        // add token to allowlist
        signatureAllowance.addTokenToAllowlist(address(tokenToBeAdded));

        // ensure token is added to allowlist
        assertTrue(
            signatureAllowance.checkTokenAllowlisted(address(tokenToBeAdded))
        );
        console2.log(
            "SignatureAllowance [Passed]: User can add token that is not in allowlist"
        );
    }

    function testUserCannotAddTokenAlreadyAllowlisted() public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));
        console2.log(
            "SignatureAllowance: User trying to add token that is added to allowlist"
        );
        // create new token
        address tokenToBeAdded = address(new MockToken());

        // add token to allowlist
        signatureAllowance.addTokenToAllowlist(tokenToBeAdded);

        // ensure token is added to allowlist
        assertTrue(signatureAllowance.checkTokenAllowlisted(tokenToBeAdded));

        // expect revert when adding token to allowlist while the token is already in allowlist
        vm.expectRevert(SignatureAllowance.TokenAlreadyInAllowlist.selector);
        signatureAllowance.addTokenToAllowlist(tokenToBeAdded);

        // ensure token is still in allowlist
        assertTrue(signatureAllowance.checkTokenAllowlisted(tokenToBeAdded));
        console2.log(
            "SignatureAllowance [Passed]: User cannot add token that is in allowlist"
        );
    }

    function testUserTryingToRemoveTokenAlreadyAllowlisted() public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));
        console2.log(
            "SignatureAllowance: User trying to remove token that is added to allowlist"
        );
        // create new token
        address tokenToBeRemoved = address(new MockToken());

        // add token to allowlist
        signatureAllowance.addTokenToAllowlist(tokenToBeRemoved);

        // ensure token is added to allowlist
        assertTrue(signatureAllowance.checkTokenAllowlisted(tokenToBeRemoved));

        // when trying to remove the token from allowlist
        signatureAllowance.removeTokenFromAllowlist(tokenToBeRemoved);

        // ensure token is remove
        assertFalse(signatureAllowance.checkTokenAllowlisted(tokenToBeRemoved));
        console2.log(
            "SignatureAllowance [Passed]: User can remove token that is in allowlist"
        );
    }

    function testUserAddingNewDefaultTokenAlreadyAllowlisted() public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));
        // deploy new mock token to be added as default token
        address newDefaultToken = address(new MockToken());

        // add token to allowlist
        signatureAllowance.addTokenToAllowlist(newDefaultToken);

        // ensure new mock token is added to allowlist
        assertTrue(signatureAllowance.checkTokenAllowlisted(newDefaultToken));

        // ensure new allowlisted token is not default token
        assertNotEq(newDefaultToken, signatureAllowance.getDefaultToken());

        // set new default token
        signatureAllowance.setNewDefaultToken(newDefaultToken);

        // ensure new token is added as new default token
        assertEq(newDefaultToken, signatureAllowance.getDefaultToken());
    }

    function testUserAddingNewDefaultTokenNotAllowlisted() public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));
        // deploy new mock token to be added as default token
        address newDefaultToken = address(new MockToken());

        // ensure new mock token is not allowlisted
        assertFalse(signatureAllowance.checkTokenAllowlisted(newDefaultToken));

        // ensure new allowlisted token is not default token
        assertNotEq(newDefaultToken, signatureAllowance.getDefaultToken());

        // set new default token
        signatureAllowance.setNewDefaultToken(newDefaultToken);

        // ensure new token is added as new default token
        assertEq(newDefaultToken, signatureAllowance.getDefaultToken());

        // ensure new default token is allowlisted
        assertTrue(signatureAllowance.checkTokenAllowlisted(newDefaultToken));
    }

    function testNonSignerAddingTokens() public {
        console2.log(
            "SignatureAllowance: User trying to remove token that is added to allowlist"
        );
        // create new token
        address tokenToBeRemoved = address(new MockToken());

        // taking an easier approach in testing by impersonating Safe
        hoax(address(safe));

        // add token to allowlist
        signatureAllowance.addTokenToAllowlist(tokenToBeRemoved);

        // ensure token is added to allowlist
        assertTrue(signatureAllowance.checkTokenAllowlisted(tokenToBeRemoved));

        // check if non owner can remove already allowlisted token
        hoax(nonSignerAccount);

        // when trying to remove the token from allowlist
        // expect revert as the caller is not owner
        vm.expectRevert("Ownable: caller is not the owner");
        signatureAllowance.removeTokenFromAllowlist(tokenToBeRemoved);

        // ensure token is remove
        assertTrue(signatureAllowance.checkTokenAllowlisted(tokenToBeRemoved));
        console2.log(
            "SignatureAllowance [Passed]: User can remove token that is in allowlist"
        );
    }

    function testNonSignerTryingToAddTokenNotAllowlisted() public {
        startHoax(nonSignerAccount);
        console2.log(
            "SignatureAllowance: User trying to add token that isn't added to allowlist"
        );
        // create new token
        MockToken tokenToBeAdded = new MockToken();
        // add token to allowlist
        // expect revert as caller is not the owner
        vm.expectRevert("Ownable: caller is not the owner");
        signatureAllowance.addTokenToAllowlist(address(tokenToBeAdded));

        // ensure token is added to allowlist
        assertFalse(
            signatureAllowance.checkTokenAllowlisted(address(tokenToBeAdded))
        );
        console2.log(
            "SignatureAllowance [Passed]: User can add token that is not in allowlist"
        );
    }

    function testNonSignerCannotAddDefaultToken() public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(nonSignerAccount);

        // deploy new mock token to be added as default token
        address newDefaultToken = address(new MockToken());

        // ensure new mock token is not allowlisted
        assertFalse(signatureAllowance.checkTokenAllowlisted(newDefaultToken));

        // ensure new allowlisted token is not default token
        assertNotEq(newDefaultToken, signatureAllowance.getDefaultToken());

        // set new default token
        // expect revert as caller is not the owner
        vm.expectRevert("Ownable: caller is not the owner");
        signatureAllowance.setNewDefaultToken(newDefaultToken);

        // ensure new token is added as new default token
        assertNotEq(newDefaultToken, signatureAllowance.getDefaultToken());

        // ensure new default token is allowlisted
        assertFalse(signatureAllowance.checkTokenAllowlisted(newDefaultToken));
    }
}
