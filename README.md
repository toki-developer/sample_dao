# Sample DAO

console


## コントラクトの動作確認手順

### Nodeの起動
```
npx hardhat node
```

### デプロイ

```
// コンパイル
npx hardhat compile

// デプロイ
npx hardhat run --network localhost scripts/deploy.ts
```
### コンソールで動作確認

```
// コンソールの起動
npx hardhat console --network localhost
```

```
// デプロイ済みのコントラクトに接続
const Contract = await ethers.getContractFactory("TkoToken");
const contract = await Contract.attach([コントラクトのアドレス])

// contract.関数で、コントラクトの関数を実行できる
```