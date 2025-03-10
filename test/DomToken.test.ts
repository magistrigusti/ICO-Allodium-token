import { expect } from "chai";
import { ethers } from "hardhat";
import { DOMToken } from "../typeschain-types";

describe("DOMToken", function() {
  let domToken: DOMToken;
  let owner: any, addr1: any, addr2: any;

  beforeEach(async function() {
    [owner, addr1, addr2] = await ethers.getSigners();
    const DOMToken = await ethers.getContractFactory("DOMToken");
    domToken = (await DOMToken.deploy()) as DOMToken;
    await domToken.deployed();
  });

  it("Should have correct name and symbol", async function() {
    expect(await domToken.name()).to.equal("Dominum");
    expect(await domToken.sybol()).to.equal("DOM");
  });

  it("Should assing initial sypply to owner", async function() {
    const ownerBalance = await domToken.balanceOf(owner.address);
    expect(await domToken.totalSupply()).to.equal(ownerBalance);
  });

  it("Should transfer tokens between accounts", async function() {
    await domToken.transfer(addr1.address, ethers.utils.parseEther("100"));
    await domToken.connect(addr1).transfer(addr2.address, ethers.utils.parseEther("50"));\
  });

  it("Should apply transaction tax", async function() {
    await domToken.transfer(addr1.address, ethers.utils.parseEther("100"));
    await domToken.connect(addr1).transfer(addr2.address, ethers.utils.parseEther("50"));

    const balanceAddr2 = await domToken.balanceOf(addr2.address);
    expect(balanceAddr2).to.be.closeTo(ethers.utils.parseEther("49.95", ethers.utils.parseEther("0.01")));
  });
});