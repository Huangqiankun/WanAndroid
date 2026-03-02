export interface CollectListResult {
	curPage: number;
	datas: CollectListResultDatas[];
	offset: number;
	over: boolean;
	pageCount: number;
	size: number;
	total: number;
}
export interface CollectListResultDatas {
	author: string;
	chapterId: number;
	chapterName: string;
	courseId: number;
	desc: string;
	envelopePic: string;
	id: number;
	link: string;
	niceDate: string;
	origin: string;
	originId: number;
	publishTime: number;
	title: string;
	userId: number;
	visible: number;
	zan: number;
}