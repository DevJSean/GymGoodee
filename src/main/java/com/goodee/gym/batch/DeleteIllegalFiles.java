package com.goodee.gym.batch;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.goodee.gym.domain.NoticeFileAttachDTO;
import com.goodee.gym.mapper.BoardMapper;
import com.goodee.gym.util.MyFileUtils;


@Component  
public class DeleteIllegalFiles {

	@Autowired
	private BoardMapper boardMapper;
	
	// 매일 새벽 3시에 어제 첨부된 파일 중 잘못된 파일들을 찾아서 제거한다.
	@Scheduled(cron = "0 0 3 * * *")  
	public void execute() throws Exception {
		
		String yesterdayPath = MyFileUtils.getYesterdayPath();
		
		List<NoticeFileAttachDTO> noticeFileAttaches = boardMapper.selectNoticeFileAttachListAtYesterday();
		
		List<Path> yeaterdayPathes = noticeFileAttaches.stream()
				.map(fileAttach -> Paths.get(yesterdayPath, fileAttach.getNoticeFileAttachSaved()))
				.collect(Collectors.toList());
		
		noticeFileAttaches.stream()
		.map(fileAttach -> Paths.get(yesterdayPath, "s_" + fileAttach.getNoticeFileAttachSaved()))
		.forEach(path -> yeaterdayPathes.add(path));
		
		File dir = new File(yesterdayPath);
		if(dir.exists()) {
			File[] files = dir.listFiles(file -> yeaterdayPathes.contains(file.toPath()) == false);
			for(File removeFile : files) {
				removeFile.delete();
			}
		}
	}
}
