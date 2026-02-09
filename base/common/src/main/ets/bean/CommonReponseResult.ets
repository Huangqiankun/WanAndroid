export interface UserInfoResult {
	coinInfo: UserInfoResultCoinInfo;
	collectArticleInfo: UserInfoResultCollectArticleInfo;
	userInfo: UserInfoResultUserInfo;
}
export interface UserInfoResultCoinInfo {
	coinCount: number;
	level: number;
	nickname: string;
	rank: string;
	userId: number;
	username: string;
}
export interface UserInfoResultCollectArticleInfo {
	count: number;
}
export interface UserInfoResultUserInfo {
	admin: boolean;
	chapterTops: object[];
	coinCount: number;
	collectIds: number[];
	email: string;
	icon: string;
	id: number;
	nickname: string;
	password: string;
	publicName: string;
	token: string;
	type: number;
	username: string;
}