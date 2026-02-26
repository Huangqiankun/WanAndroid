export interface LoginResult {
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

export interface BannerResult {
	desc: string;
	id: number;
	imagePath: string;
	isVisible: number;
	order: number;
	title: string;
	type: number;
	url: string;
}

export interface HomeListArticleResult {
	curPage: number;
	datas: HomeListArticleResultDatas[];
	offset: number;
	over: boolean;
	pageCount: number;
	size: number;
	total: number;
}
export interface HomeListArticleResultDatas {
	adminAdd: boolean;
	apkLink: string;
	audit: number;
	author: string;
	canEdit: boolean;
	chapterId: number;
	chapterName: string;
	collect: boolean;
	courseId: number;
	desc: string;
	descMd: string;
	envelopePic: string;
	fresh: boolean;
	host: string;
	id: number;
	isAdminAdd: boolean;
	link: string;
	niceDate: string;
	niceShareDate: string;
	origin: string;
	prefix: string;
	projectLink: string;
	publishTime: number;
	realSuperChapterId: number;
	selfVisible: number;
	shareDate: number;
	shareUser: string;
	superChapterId: number;
	superChapterName: string;
	tags: object[];
	title: string;
	type: number;
	userId: number;
	visible: number;
	zan: number;
}